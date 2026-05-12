const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');

const app = express();

app.set('view engine', 'ejs');
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true}));
app.use(express.static(path.join(__dirname, 'public')));

const dbConfig = {
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'ygeiopolis'
};

app.get('/', async(req, res) => {
    res.render('home');
});

app.get('/patients', async (req,res) => {
    try{
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute('SELECT ssn, name, surname, age, insurance_provider FROM patient LIMIT 50');
        await connection.end();
        res.render('patients', { patients: rows });
    }catch(error){
        console.error(error);
        res.status(500).send("Error retrieving patients");
    }
});

app.get('/staff', async(req,res) => {
    try{
        const connection = await mysql.createConnection(dbConfig);
        const [doctors] = await connection.execute(`
            SELECT s.name, s.surname, d.specialty, d.rank, d.medical_license_no
            FROM staff s
            JOIN doctor d ON s.ssn = d.staff_ssn
            `);
            await connection.end();
            res.render('staff', { doctors: doctors });
    }catch(error){
        console.error(error);
        res.status(500).send("Error retrieving staff");
    }
});

app.get('/departments', async (req,res) =>{
    try{
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(`
            SELECT d.name, d.floor_building, d.bed_count, s.surname AS director_name
            FROM department d
            LEFT JOIN doctor doc ON d.director_ssn = doc.ssn
            LEFT JOIN staff s ON doc.staff_ssn = s.ssn
            `);
        await connection.end();
        res.render('departments', { departments: rows});
    }catch(error){
        console.error(error);
        res.status(500).send("Error retrieving departments");
    }
});

app.get('/pharmacy', async (req,res) => {
    try{
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(`
            SELECT m.name AS medication_name, m.ema_code, GROUP_CONCAT(asub.name SEPARATOR ', ') AS substances
            FROM medication m
            LEFT JOIN medication_substance ms ON m.medication_id = ms.medication_id
            LEFT JOIN active_substance asub ON ms.substance_id = asub.substance_id
            GROUP BY m.medication_id
            `);
        await connection.end();
        res.render('pharmacy', { medications: rows});
    }catch (error){
        console.error(error);
        res.status(500).send("Error retrieving pharmacy data");
    }
});

app.get('/triage', async (req, res) => {
    try{
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(`
            SELECT t.triage_id, p.name, p.surname, t.urgency_level, t.arrival_time, t.symptoms, t.outcome
            FROM triage t
            JOIN patient p ON t.patient_ssn = p.ssn
            WHERE t.outcome != 'DISCHARGED' AND t.hospitalization_id IS NULL
            ORDER BY t.urgency_level ASC, t.arrival_time ASC
            `);
        await connection.end();
        res.render('triage', { cases: rows, error: req.query.error || null});
    }catch(error){
        console.error(error);
        res.status(500).send("Error retrieving triage data");
    }
});

app.post('/triage/new', async (req,res) => {
    let connection;
    try{
        const { patient_ssn, nurse_ssn, urgency_level, symptoms } = req.body;
        connection = await mysql.createConnection(dbConfig);
        const [patientExists] = await connection.execute('SELECT ssn FROM patient WHERE ssn = ?', [patient_ssn]);
        const [nurseExists] = await connection.execute('SELECT ssn FROM nurse WHERE ssn = ?', [nurse_ssn]);
        if(patientExists.length === 0 || nurseExists.length === 0){
            await connection.end();
            return res.redirect('/triage?error=invalid_id');
        }
        await connection.execute(`
            INSERT INTO triage (patient_ssn, nurse_ssn, urgency_level, symptoms, arrival_time, outcome)
            VALUES (?,?,?,?, NOW(), 'ADMITTED')
            `, [patient_ssn, nurse_ssn, urgency_level, symptoms]);
        res.redirect('/triage');
    }catch(error){
        console.error("Error saving triage: ", error);
        res.status(500).send("Error saving triage");
    } finally{
        if (connection && connection.connection._fatalError === null) {
            await connection.end();
        }
    }
});

app.get('/admission/:triage_id', async (req,res) => {
    let connection;
    try{
        const triage_id = req.params.triage_id;
        connection = await mysql.createConnection(dbConfig);

        const [triageData] = await connection.execute(`
            SELECT t.*, p.name, p.surname
            FROM triage t
            JOIN patient p ON t.patient_ssn = p.ssn
            WHERE t.triage_id = ?`, [triage_id]);
        
        const [beds] = await connection.execute(`
            SELECT b.bed_id, b.unique_number, d.name AS dept_name
            FROM bed b
            JOIN department d ON b.department_id = d.department_id
            WHERE b.status = 'AVAILABLE'`);

        const [kenCodes] = await connection.execute('SELECT ken_code, description FROM ken');
        const [icd10] = await connection.execute('SELECT code, description FROM icd10 LIMIT 100');
        res.render('admission', {
            triage: triageData[0],
            beds: beds,
            kenCodes: kenCodes,
            icd10: icd10
        });
    }catch(error){
        console.error(error);
        res.status(500).send("Error preparing admission");
    }finally{
        if(connection) await connection.end();
    }
});

app.post('/admission/complete', async (req,res) => {
    let connection;
    try {
        const {triage_id, patient_ssn, bed_id, ken_code, diagnosis_code, diagnosis_desc } = req.body;
        connection = await mysql.createConnection(dbConfig);

        await connection.beginTransaction();

        const [bedInfo] = await connection.execute('SELECT department_id FROM bed WHERE bed_id = ?', [bed_id]);
        const dept_id = bedInfo[0].department_id;

        const [hospResult] = await connection.execute(`
            INSERT INTO hospitalization (patient_ssn, bed_id, department_id, ken_code, admission_date, admission_diagnosis_code, admission_diagnosis_desc)
            VALUES (?, ?, ?, ?, CURDATE(), ?, ?)
            `, [patient_ssn, bed_id, dept_id, ken_code, diagnosis_code, diagnosis_desc]);
        
        const newHospId = hospResult.insertId;

        await connection.execute('UPDATE triage SET hospitalization_id = ? WHERE triage_id = ?', [newHospId, triage_id]);

        await connection.execute("UPDATE bed SET status = 'OCCUPIED' WHERE bed_id = ?", [bed_id]);

        await connection.commit();
        res.redirect('/triage');
    }catch(error) {
        if(connection) await connection.rollback();
        console.error("Admission Transaction Failed: ", error);
        res.status(500).send("Admission Error");
    }finally {
        if(connection) await connection.end();
    }
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});