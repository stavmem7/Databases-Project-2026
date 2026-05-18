SELECT 
    d.name AS department,
    YEAR(h.admission_date) AS year,
    h.ken_code,
    k.base_cost,
    COUNT(h.hospitalization_id) AS total_hospitalizations,
    SUM(k.base_cost) AS total_base_cost,
    SUM(h.total_cost - k.base_cost) AS extra_charge,
    SUM(h.total_cost) AS total_revenue,
    p.insurance_provider,
    COUNT(p.ssn) AS patients_per_provider
FROM hospitalization h
JOIN department d ON h.department_id = d.department_id
JOIN ken k ON h.ken_code = k.ken_code
JOIN patient p ON h.patient_ssn = p.ssn
GROUP BY d.department_id, YEAR(h.admission_date), h.ken_code, p.insurance_provider
ORDER BY year, department, h.ken_code;