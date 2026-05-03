SELECT 
    do.ousia_id,
    do.onoma AS drastiki_ousia,
    COUNT(DISTINCT al.AMKA_astheni) AS plithos_allergikon_asthenon,
    COUNT(DISTINCT fo.farmako_id) AS plithos_farmakon
FROM drastiki_ousia do
LEFT JOIN allergia al ON do.ousia_id = al.ousia_id
LEFT JOIN farmako_ousia fo ON do.ousia_id = fo.ousia_id
GROUP BY do.ousia_id, do.onoma
ORDER BY plithos_allergikon_asthenon DESC;