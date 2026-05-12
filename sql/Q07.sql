SELECT 
    a.substance_id,
    a.name AS active_substance,
    COUNT(DISTINCT al.patient_ssn) AS allergic_patients,
    COUNT(DISTINCT ms.medication_id) AS medications_count
FROM active_substance a
LEFT JOIN allergy al ON a.substance_id = al.substance_id
LEFT JOIN medication_substance ms ON a.substance_id = ms.substance_id
GROUP BY a.substance_id, a.name
ORDER BY allergic_patients DESC;