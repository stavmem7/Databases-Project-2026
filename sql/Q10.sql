SELECT 
    do1.onoma AS ousia_1,
    do2.onoma AS ousia_2,
    COUNT(*) AS syllogos
FROM syntagografisi s1
JOIN syntagografisi s2 ON s1.AMKA_astheni = s2.AMKA_astheni
    AND s1.nosileia_id = s2.nosileia_id
    AND s1.farmako_id < s2.farmako_id
JOIN farmako_ousia fo1 ON s1.farmako_id = fo1.farmako_id
JOIN farmako_ousia fo2 ON s2.farmako_id = fo2.farmako_id
JOIN drastiki_ousia do1 ON fo1.ousia_id = do1.ousia_id
JOIN drastiki_ousia do2 ON fo2.ousia_id = do2.ousia_id
WHERE fo1.ousia_id < fo2.ousia_id
GROUP BY do1.ousia_id, do2.ousia_id, do1.onoma, do2.onoma
ORDER BY syllogos DESC
LIMIT 3;