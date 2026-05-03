SELECT 
    doc.ssn,
    s.name,
    s.surname,
    doc.specialty,
    doc.rank,
    CASE WHEN COUNT(DISTINCT sp.shift_id) > 0 THEN 'YES' ELSE 'NO' END AS had_shift,
    COUNT(DISTINCT mp.procedure_id) AS total_procedures
FROM doctor doc
JOIN staff s ON doc.ssn = s.ssn
LEFT JOIN shift_participation sp ON doc.ssn = sp.staff_ssn
    AND sp.shift_id IN (
        SELECT shift_id FROM shift WHERE YEAR(date) = YEAR(CURDATE())
    )
LEFT JOIN medical_procedure mp ON doc.ssn = mp.chief_surgeon_ssn
WHERE doc.specialty = 'Καρδιολογία'
GROUP BY doc.ssn, s.name, s.surname, doc.specialty, doc.rank
ORDER BY total_procedures DESC;