SELECT 
    a.AMKA,
    a.onoma,
    a.eponymo,
    t.onoma AS tmima,
    COUNT(n.nosileia_id) AS plithos_nosilion,
    SUM(n.synoliko_kostos) AS synoliko_kostos
FROM asthenis a
JOIN nosileia n ON a.AMKA = n.AMKA_astheni
JOIN tmima t ON n.tmima_id = t.tmima_id
GROUP BY a.AMKA, a.onoma, a.eponymo, n.tmima_id, t.onoma
HAVING COUNT(n.nosileia_id) > 3
ORDER BY plithos_nosilion DESC;