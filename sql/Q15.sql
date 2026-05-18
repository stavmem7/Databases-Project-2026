SELECT 
    t.urgency_level,
    COUNT(t.triage_id) AS total_cases,
    ROUND(COUNT(t.triage_id) * 100.0 / (SELECT COUNT(*) FROM triage), 2) AS percentage,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, t.arrival_time, t.service_time)), 2) AS wait_time,
    SUM(CASE WHEN t.outcome = 'ADMITTED' THEN 1 ELSE 0 END) AS admitted_count,
    ROUND(SUM(CASE WHEN t.outcome = 'ADMITTED' THEN 1 ELSE 0 END) * 100.0 / COUNT(t.triage_id), 2) AS admission_percentage,
    d.name AS department,
    COUNT(h.hospitalization_id) AS referrals_per_department
FROM triage t
LEFT JOIN hospitalization h ON t.hospitalization_id = h.hospitalization_id
LEFT JOIN department d ON h.department_id = d.department_id
GROUP BY t.urgency_level, d.department_id, d.name
ORDER BY t.urgency_level, referrals_per_department DESC;