SELECT 
    doc.ssn,
    s.name,
    s.surname,
    doc.specialty,
    COUNT(mp.procedure_id) AS total_procedures
FROM doctor doc
JOIN staff s ON doc.ssn = s.ssn
LEFT JOIN medical_procedure mp ON doc.ssn = mp.chief_surgeon_ssn
    AND YEAR(mp.start_datetime) = 2024
GROUP BY doc.ssn, s.name, s.surname, doc.specialty
HAVING COUNT(mp.procedure_id) <= (
    SELECT MAX(cnt) - 5
    FROM (
        SELECT COUNT(procedure_id) AS cnt
        FROM medical_procedure
        WHERE YEAR(start_datetime) = 2024
        GROUP BY chief_surgeon_ssn
    ) AS counts
)
ORDER BY total_procedures DESC;