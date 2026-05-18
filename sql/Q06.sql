SELECT 
    p.ssn, 
    p.name, 
    p.surname,
    h.hospitalization_id,
    h.admission_date,
    h.discharge_date,
    h.admission_diagnosis_code,
    icd.description AS diagnosis,
    h.total_cost,
    ROUND(AVG(hr.overall_experience), 2) AS avg_overall_experience
FROM patient p 
JOIN hospitalization h ON h.patient_ssn = p.ssn
JOIN icd10 icd ON h.admission_diagnosis_code = icd.code
LEFT JOIN hospitalization_review hr ON h.hospitalization_id = hr.hospitalization_id
WHERE p.ssn = '00000000657'
GROUP BY p.ssn, p.name, p.surname, h.hospitalization_id, h.admission_date, 
         h.discharge_date, h.admission_diagnosis_code, icd.description, h.total_cost
ORDER BY h.admission_date;