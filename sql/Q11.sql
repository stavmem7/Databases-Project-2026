SELECT 
    i.AMKA,
    p.onoma,
    p.eponymo,
    i.eidikotita,
    COUNT(ip.praxi_id) AS plithos_epemvaseon
FROM iatros i
JOIN proswpiko p ON i.AMKA = p.AMKA
LEFT JOIN iatriki_praxi ip ON i.AMKA = ip.AMKA_kyriou_xeirourgou
    AND YEAR(ip.im_wra_enarxis) = 2024
GROUP BY i.AMKA, p.onoma, p.eponymo, i.eidikotita
HAVING COUNT(ip.praxi_id) <= (
    SELECT MAX(cnt) - 5
    FROM (
        SELECT COUNT(praxi_id) AS cnt
        FROM iatriki_praxi
        WHERE YEAR(im_wra_enarxis) = 2024
        GROUP BY AMKA_kyriou_xeirourgou
    ) AS counts
)
ORDER BY plithos_epemvaseon DESC;