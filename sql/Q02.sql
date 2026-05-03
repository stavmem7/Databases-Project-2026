SELECT 
    i.AMKA,
    p.onoma,
    p.eponymo,
    i.eidikotita,
    i.vathmida,
    CASE WHEN COUNT(DISTINCT sv.vardia_id) > 0 THEN 'ΝΑΙ' ELSE 'ΟΧΙ' END AS eixe_efimeria,
    COUNT(DISTINCT ip.praxi_id) AS plithos_epemvaseon
FROM iatros i
JOIN proswpiko p ON i.AMKA = p.AMKA
LEFT JOIN symmetoxi_vardias sv ON i.AMKA = sv.AMKA_proswpikou
    AND sv.vardia_id IN (
        SELECT vardia_id FROM vardia WHERE YEAR(imerominia) = YEAR(CURDATE())
    )
LEFT JOIN iatriki_praxi ip ON i.AMKA = ip.AMKA_kyriou_xeirourgou
WHERE i.eidikotita = 'Καρδιολογία'
GROUP BY i.AMKA, p.onoma, p.eponymo, i.eidikotita, i.vathmida
ORDER BY plithos_epemvaseon DESC;