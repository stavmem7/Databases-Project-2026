SELECT 
    p1.ssn AS ssn1,
    p1.name AS name1,
    p1.surname AS surname1,
    p2.ssn AS ssn2,
    p2.name AS name2,
    p2.surname AS surname2,
    SUM(DATEDIFF(h1.discharge_date, h1.admission_date)) AS total_days,
    YEAR(h1.admission_date) AS year
FROM patient p1
JOIN patient p2 ON p1.ssn < p2.ssn
JOIN hospitalization h1 ON p1.ssn = h1.patient_ssn
JOIN hospitalization h2 ON p2.ssn = h2.patient_ssn
WHERE YEAR(h1.admission_date) = YEAR(h2.admission_date)
AND h1.discharge_date IS NOT NULL
AND h2.discharge_date IS NOT NULL
GROUP BY p1.ssn, p2.ssn, YEAR(h1.admission_date)
HAVING SUM(DATEDIFF(h1.discharge_date, h1.admission_date)) = SUM(DATEDIFF(h2.discharge_date, h2.admission_date))
AND SUM(DATEDIFF(h1.discharge_date, h1.admission_date)) > 15
ORDER BY total_days DESC;