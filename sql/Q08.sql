SELECT 
    p.AMKA,
    p.onoma,
    p.eponymo,
    p.typos
FROM proswpiko p
WHERE p.AMKA NOT IN (
    SELECT sv.AMKA_proswpikou
    FROM symmetoxi_vardias sv
    JOIN vardia v ON sv.vardia_id = v.vardia_id
    WHERE v.imerominia = '2024-05-29' 
    AND v.tmima_id = 2                 
)
ORDER BY p.typos, p.eponymo;