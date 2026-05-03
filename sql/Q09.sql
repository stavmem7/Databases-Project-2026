SELECT 
    a1.AMKA AS AMKA_astheni1,
    a1.onoma AS onoma1,
    a1.eponymo AS eponymo1,
    a2.AMKA AS AMKA_astheni2,
    a2.onoma AS onoma2,
    a2.eponymo AS eponymo2,
    SUM(DATEDIFF(n1.im_exodou, n1.im_eisagogis)) AS synolikes_imeres,
    YEAR(n1.im_eisagogis) AS etos
FROM asthenis a1
JOIN asthenis a2 ON a1.AMKA < a2.AMKA
JOIN nosileia n1 ON a1.AMKA = n1.AMKA_astheni
JOIN nosileia n2 ON a2.AMKA = n2.AMKA_astheni
WHERE YEAR(n1.im_eisagogis) = YEAR(n2.im_eisagogis)
AND n1.im_exodou IS NOT NULL
AND n2.im_exodou IS NOT NULL
GROUP BY a1.AMKA, a1.onoma, a1.eponymo, a2.AMKA, a2.onoma, a2.eponymo, YEAR(n1.im_eisagogis)
HAVING SUM(DATEDIFF(n1.im_exodou, n1.im_eisagogis)) = SUM(DATEDIFF(n2.im_exodou, n2.im_eisagogis))
AND SUM(DATEDIFF(n1.im_exodou, n1.im_eisagogis)) > 15
ORDER BY synolikes_imeres DESC;