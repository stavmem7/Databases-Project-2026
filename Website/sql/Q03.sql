SELECT 
    p.ssn,
    p.name,
    p.surname,
    d.name AS department,
    COUNT(h.hospitalization_id) AS total_hospitalizations,
    SUM(h.total_cost) AS total_cost
FROM patient p
JOIN hospitalization h ON p.ssn = h.patient_ssn
JOIN department d ON h.department_id = d.department_id
GROUP BY p.ssn, p.name, p.surname, h.department_id, d.name
HAVING COUNT(h.hospitalization_id) > 3
ORDER BY total_hospitalizations DESC;
