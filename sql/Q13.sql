WITH RECURSIVE supervision_hierarchy AS (
    SELECT 
        d.ssn,
        s.name,
        s.surname,
        d.specialty,
        d.rank,
        d.supervisor_ssn,
        0 AS level
    FROM doctor d
    JOIN staff s ON d.ssn = s.ssn
    WHERE d.ssn = '00000000007'  

    UNION ALL

    SELECT 
        d.ssn,
        s.name,
        s.surname,
        d.specialty,
        d.rank,
        d.supervisor_ssn,
        sh.level + 1
    FROM doctor d
    JOIN staff s ON d.ssn = s.ssn
    JOIN supervision_hierarchy sh ON d.ssn = sh.supervisor_ssn
)
SELECT 
    ssn,
    name,
    surname,
    specialty,
    rank,
    level
FROM supervision_hierarchy
ORDER BY level;