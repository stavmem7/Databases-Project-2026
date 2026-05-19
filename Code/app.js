const express = require('express');
const mysql = require('mysql2/promise');
const path = require('path');

const app = express();

app.set('view engine', 'ejs');
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.urlencoded({ extended: true}));
app.use(express.static(path.join(__dirname, 'public')));

app.use((req,res,next) => {
    res.locals.role = req.query.role || null;
    next();
});


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
            SELECT s.name, s.surname, d.specialty, d.rank, d.medical_license_no,
                (SELECT url FROM image 
                 WHERE entity_type = 'doctor' AND entity_id = CAST(d.ssn AS UNSIGNED) 
                 LIMIT 1) AS photo_url
            FROM staff s
            JOIN doctor d ON s.ssn = d.staff_ssn
            `);
        await connection.end();
        console.log('First doctor photo_url:', doctors[0]?.photo_url);
        res.render('staff', { doctors: doctors, role: req.query.role || null });
    }catch(error){
        console.error(error);
        res.status(500).send("Error retrieving staff");
    }
});

app.get('/departments', async (req,res) =>{
    try{
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(`
            SELECT d.name, d.floor_building, d.bed_count, 
                   s.surname AS director_name,
                   (SELECT url FROM image 
                    WHERE entity_type = 'department' AND entity_id = d.department_id 
                    LIMIT 1) AS photo_url
            FROM department d
            LEFT JOIN doctor doc ON d.director_ssn = doc.ssn
            LEFT JOIN staff s ON doc.staff_ssn = s.ssn
            `);
        await connection.end();
        res.render('departments', { departments: rows, role: req.query.role || null });
    }catch(error){
        console.error(error);
        res.status(500).send("Error retrieving departments");
    }
});


app.get('/pharmacy', async (req,res) => {
    try{
        const connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(`
            SELECT m.name AS medication_name, m.ema_code, 
                   GROUP_CONCAT(asub.name SEPARATOR ', ') AS substances,
                   (SELECT url FROM image 
                    WHERE entity_type = 'medication' AND entity_id = m.medication_id 
                    LIMIT 1) AS photo_url
            FROM medication m
            LEFT JOIN medication_substance ms ON m.medication_id = ms.medication_id
            LEFT JOIN active_substance asub ON ms.substance_id = asub.substance_id
            GROUP BY m.medication_id
            `);
        await connection.end();
        res.render('pharmacy', { medications: rows, role: req.query.role || null });
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
    const role = req.query.role;
    try{
        const { patient_ssn, nurse_ssn, urgency_level, symptoms } = req.body;
        connection = await mysql.createConnection(dbConfig);
        const [patientExists] = await connection.execute('SELECT ssn FROM patient WHERE ssn = ?', [patient_ssn]);
        const [nurseExists] = await connection.execute('SELECT ssn FROM nurse WHERE ssn = ?', [nurse_ssn]);
        if(patientExists.length === 0 || nurseExists.length === 0){
            await connection.end();
            return res.redirect(`/triage?role=${role}&error=invalid_id`);
        }
        await connection.execute(`
            INSERT INTO triage (patient_ssn, nurse_ssn, urgency_level, symptoms, arrival_time, outcome)
            VALUES (?,?,?,?, NOW(), 'ADMITTED')
            `, [patient_ssn, nurse_ssn, urgency_level, symptoms]);
        res.redirect('/triage?role=' + req.query.role);
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
    const role = req.query.role;
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
            icd10: icd10,
            role: role
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
    const role = req.query.role;
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
        res.redirect(`/triage?role=${role}`);
    }catch(error) {
        if(connection) await connection.rollback();
        console.error("Admission Transaction Failed: ", error);
        res.status(500).send("Admission Error");
    }finally {
        if(connection) await connection.end();
    }
});

app.get('/hospitalizations', async (req,res) => {
    let connection;
    const role = req.query.role;
    try{
        connection = await mysql.createConnection(dbConfig);
        const [rows] = await connection.execute(`
            SELECT h.hospitalization_id, p.name, p.surname, d.name AS dept_name, b.unique_number AS bed_no, h.admission_date
            FROM hospitalization h
            JOIN patient p ON h.patient_ssn = p.ssn
            JOIN department d ON h.department_id = d.department_id
            JOIN bed b ON h.bed_id = b.bed_id
            WHERE h.discharge_date IS NULL
            ORDER BY h.admission_date DESC
            `);
        
        res.render('hospitalizations', { admissions: rows, role: role});
    }catch(error){
        console.error(error);
        res.status(500).send("Error retrieving hospitalizations");
    }finally{
        if (connection) await connection.end();
    }
});

app.get('/hospitalizations/:hosp_id/tests', async (req, res) => {
    let connection; 
    const role = req.query.role; 
    try {
        const hosp_id = req.params.hosp_id; 
        connection = await mysql.createConnection(dbConfig); 

        const [tests] = await connection.execute(`
            SELECT type, date, result_text, result_numeric, unit, code
            FROM lab_test 
            WHERE hospitalization_id = ?
            ORDER BY date DESC`, [hosp_id]); 

        res.render('tests', { tests: tests, hosp_id: hosp_id, role: role }); 
    } catch (error) {
        console.error(error); 
        res.status(500).send("Error retrieving lab tests"); 
    } finally {
        if (connection) await connection.end(); 
    } 
});

app.get('/prescription/new/:hosp_id', async (req,res) => {
    let connection;
    const role = req.query.role;
    try{
        const hosp_id = req.params.hosp_id;
        connection = await mysql.createConnection(dbConfig);

        const [hospInfo] = await connection.execute(`
            SELECT h.hospitalization_id, p.name, p.surname, p.ssn
            FROM hospitalization h
            JOIN patient p ON h.patient_ssn = p.ssn
            WHERE h.hospitalization_id = ?`, [hosp_id]);

        const [meds] = await connection.execute(`
            SELECT medication_id, name FROM medication`);

        const [doctors] = await connection.execute(`
            SELECT d.ssn, s.surname
            FROM doctor d
            JOIN staff s ON d.staff_ssn = s.ssn`);

        res.render('new_prescription', {
            hosp: hospInfo[0],
            meds: meds,
            doctors: doctors,
            error: req.query.error || null,
            substance: req.query.substance || null,
            role: role
        });
    } catch (error) {
        console.error(error);
        res.status(500).send("Error preparing prescription");
    } finally {
        if (connection) await connection.end();
    }
});


app.post('/prescription/save', async (req, res) => {
    let connection;
    const role = req.query.role;
    try {
        const { hospitalization_id, patient_ssn, doctor_ssn, medication_id, dosage, frequency } = req.body;

        connection = await mysql.createConnection(dbConfig);
    
        const [allergyCheck] = await connection.execute(`
            SELECT asub.name AS substance_name
            FROM medication_substance ms
            JOIN active_substance asub ON ms.substance_id = asub.substance_id
            JOIN allergy a ON a.substance_id = asub.substance_id
            WHERE ms.medication_id = ? AND a.patient_ssn = ?
            `, [medication_id, patient_ssn]);
        
        if (allergyCheck.length > 0) {
            const substance = allergyCheck[0].substance_name;
            return res.redirect(`/prescription/new/${hospitalization_id}?role=${role}&error=allergy&substance=${substance}`);
        }

        await connection.execute(`
            INSERT INTO prescription (doctor_ssn, patient_ssn, medication_id, hospitalization_id, dosage, frequency, start_date)
            VALUES (?,?,?,?,?,?, CURDATE())
            `, [doctor_ssn, patient_ssn, medication_id, hospitalization_id, dosage, frequency]);
        
        res.redirect(`/hospitalizations?role=${role}`);
    } catch (error) {
        console.error(error);
        res.status(500).send("Error during prescription");
    } finally {
        if (connection) await connection.end();
    }
});

app.post('/discharge/:hosp_id', async (req,res) => {
    let connection;
    const role = req.query.role;
    try{
        const hosp_id = req.params.hosp_id;
        connection = await mysql.createConnection(dbConfig);

        await connection.beginTransaction();

        const [hospData] = await connection.execute(`
            SELECT bed_id FROM hospitalization WHERE hospitalization_id = ?`, [hosp_id]);
        
        if (hospData.length>0){
            const bed_id = hospData[0].bed_id;

            await connection.execute(`
                UPDATE hospitalization SET discharge_date = CURDATE() WHERE hospitalization_id = ?
                `, [hosp_id]);

            await connection.execute(
                "UPDATE bed SET status = 'AVAILABLE' WHERE bed_id = ?",[bed_id]
            );
        }

        await connection.commit();
        res.redirect(`/hospitalizations?role=${role}`);    
    } catch(error){
        if (connection) await connection.rollback();
        console.error("Discharge Error: ", error);
        res.status(500).send("Error during Discharge");
    } finally{
        if (connection) await connection.end();
    }
});

app.get('/dashboard', async (req,res) => {
    let connection;
    const role = req.query.role;
    try{
        connection = await mysql.createConnection(dbConfig);

        const [hospCount] = await connection.execute(`
            SELECT COUNT(*) AS total FROM hospitalization WHERE discharge_date IS NULL 
            `);

        const [triageWait] = await connection.execute(`
            SELECT COUNT(*) AS total FROM triage WHERE hospitalization_id IS NULL AND outcome != 'DISCHARGED'
            `);

        const [deptStats] = await connection.execute(`
            SELECT d.name, d.bed_count,
                (SELECT COUNT(*) FROM bed b WHERE b.department_id = d.department_id AND b.status = 'OCCUPIED') AS occupied_beds
            FROM department d
            `);
        const [recentAdmissions] = await connection.execute(`
            SELECT p.name, p.surname, d.name AS dept_name, h.admission_date
            FROM hospitalization h
            JOIN patient p ON h.patient_ssn = p.ssn
            JOIN department d ON h.department_id = d.department_id
            ORDER BY h.admission_date DESC LIMIT 5
            `);
        
            res.render('dashboard' , {
                stats: {
                    currentPatients: hospCount[0].total,
                    triageWaiting: triageWait[0].total
                },
                deptStats: deptStats,
                recent: recentAdmissions,
                role: role
            });
    }catch(error){
        console.error(error);
        res.status(500).send("Error loading dashboard");
    }
});

app.get('/my-results', async(req,res) => {
    let connection;
    const role = req.query.role;
    try {
        const ssn = req.query.ssn;
        if (!ssn) return res.redirect('/?role=patient');

        connection = await mysql.createConnection(dbConfig);

        const [patientInfo] = await connection.execute(`
            SELECT name, surname FROM patient WHERE ssn = ?`, [ssn]);

        const [history] = await connection.execute(`
            SELECT h.admission_date, h.discharge_date, h.admission_diagnosis_desc, d.name AS dept_name
            FROM hospitalization h
            JOIN department d ON h.department_id = d.department_id
            WHERE h.patient_ssn = ?
            ORDER BY h.admission_date DESC`, [ssn]
        );

        res.render('my-results', {
            patient: patientInfo[0] || null,
            history: history,
            ssn: ssn,
            role: role
        });
    } catch (error){
        console.error(error);
        res.status(500).send("Error during search");
    } finally {
        if (connection) await connection.end();
    }
});


const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});