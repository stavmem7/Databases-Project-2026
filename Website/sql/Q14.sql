SELECT 
    h1.admission_diagnosis_code,
    i.description,
    YEAR(h1.admission_date) AS year1,
    COUNT(DISTINCT h1.hospitalization_id) AS count_year1,
    YEAR(h2.admission_date) AS year2,
    COUNT(DISTINCT h2.hospitalization_id) AS count_year2
FROM hospitalization h1
JOIN hospitalization h2 
    ON h1.admission_diagnosis_code = h2.admission_diagnosis_code
    AND YEAR(h2.admission_date) = YEAR(h1.admission_date) + 1
JOIN icd10 i ON h1.admission_diagnosis_code = i.code
WHERE YEAR(h1.admission_date) < YEAR(h2.admission_date)
GROUP BY h1.admission_diagnosis_code, i.description, YEAR(h1.admission_date), YEAR(h2.admission_date)
HAVING COUNT(DISTINCT h1.hospitalization_id) = COUNT(DISTINCT h2.hospitalization_id)
AND COUNT(DISTINCT h1.hospitalization_id) >= 5
ORDER BY year1, count_year1 DESC;