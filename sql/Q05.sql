SELECT 
    i.AMKA,
    p.onoma,
    p.eponymo,
    p.ilikia,
    i.eidikotita,
    i.vathmida,
    COUNT(ip.praxi_id) AS plithos_xeirourgikon
FROM iatros i
JOIN proswpiko p ON i.AMKA = p.AMKA
JOIN iatriki_praxi ip ON i.AMKA = ip.AMKA_kyriou_xeirourgou
WHERE p.ilikia < 35
AND ip.katigoria = 'XEIROURGIKI'
GROUP BY i.AMKA, p.onoma, p.eponymo, p.ilikia, i.eidikotita, i.vathmida
ORDER BY plithos_xeirourgikon DESC;