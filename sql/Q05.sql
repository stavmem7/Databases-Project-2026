SELECT 
    doc.ssn,
    s.name,
    s.surname,
    s.age,
    doc.specialty,
    doc.rank,
    COUNT(mp.procedure_id) AS total_surgical
FROM doctor doc
JOIN staff s ON doc.ssn = s.ssn
JOIN medical_procedure mp ON doc.ssn = mp.chief_surgeon_ssn
WHERE s.age < 35
AND mp.category = 'SURGICAL'
GROUP BY doc.ssn, s.name, s.surname, s.age, doc.specialty, doc.rank
ORDER BY total_surgical DESC;