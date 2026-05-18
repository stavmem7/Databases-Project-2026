SELECT 
    s.ssn,
    s.name,
    s.surname,
    s.type
FROM staff s
WHERE s.ssn NOT IN (
    SELECT sp.staff_ssn
    FROM shift_participation sp
    JOIN shift sh ON sp.shift_id = sh.shift_id
    WHERE sh.date = '2024-05-29'
    AND sh.department_id = 1
)
ORDER BY s.type, s.surname;