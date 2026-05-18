SELECT 
    a1.name AS substance_1,
    a2.name AS substance_2,
    COUNT(*) AS frequency
FROM prescription pr1
JOIN prescription pr2 ON pr1.patient_ssn = pr2.patient_ssn
    AND pr1.hospitalization_id = pr2.hospitalization_id
    AND pr1.medication_id < pr2.medication_id
JOIN medication_substance ms1 ON pr1.medication_id = ms1.medication_id
JOIN medication_substance ms2 ON pr2.medication_id = ms2.medication_id
JOIN active_substance a1 ON ms1.substance_id = a1.substance_id
JOIN active_substance a2 ON ms2.substance_id = a2.substance_id
WHERE ms1.substance_id < ms2.substance_id
GROUP BY a1.substance_id, a2.substance_id, a1.name, a2.name
ORDER BY frequency DESC
LIMIT 3;