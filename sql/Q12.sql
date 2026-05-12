SELECT 
    d.name AS department,
    sh.date,
    sh.type AS shift,
    s.type AS staff_type,
    CASE 
        WHEN s.type = 'DOCTOR' THEN doc.specialty
        WHEN s.type = 'NURSE' THEN n.rank
        WHEN s.type = 'ADMINISTRATIVE' THEN ads.role
    END AS subclass,
    COUNT(sp.staff_ssn) AS total
FROM shift sh
JOIN department d ON sh.department_id = d.department_id
JOIN shift_participation sp ON sh.shift_id = sp.shift_id
JOIN staff s ON sp.staff_ssn = s.ssn
LEFT JOIN doctor doc ON s.ssn = doc.ssn
LEFT JOIN nurse n ON s.ssn = n.staff_ssn
LEFT JOIN administrative_staff ads ON s.ssn = ads.staff_ssn
WHERE sh.date BETWEEN '2024-01-01' AND '2024-01-07'
GROUP BY d.department_id, d.name, sh.date, sh.type, s.type, subclass
ORDER BY d.name, sh.date, sh.type, s.type;