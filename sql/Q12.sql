    SELECT 
    t.onoma AS tmima,
    v.imerominia,
    v.typos AS vardia,
    p.typos AS typos_proswpikou,
    CASE 
        WHEN p.typos = 'IATROS' THEN i.eidikotita
        WHEN p.typos = 'NOSILEUTIS' THEN n.vathmida
        WHEN p.typos = 'DIOIKITIKO' THEN dp.rolos
    END AS ypoklasi,
    COUNT(sv.AMKA_proswpikou) AS plithos
FROM vardia v
JOIN tmima t ON v.tmima_id = t.tmima_id
JOIN symmetoxi_vardias sv ON v.vardia_id = sv.vardia_id
JOIN proswpiko p ON sv.AMKA_proswpikou = p.AMKA
LEFT JOIN iatros i ON p.AMKA = i.AMKA
LEFT JOIN nosileutis n ON p.AMKA = n.AMKA_proswpikou
LEFT JOIN dioikitiko_proswpiko dp ON p.AMKA = dp.AMKA_proswpikou
WHERE v.imerominia BETWEEN '2024-01-01' AND '2024-01-07'
GROUP BY t.tmima_id, t.onoma, v.imerominia, v.typos, p.typos, ypoklasi
ORDER BY t.onoma, v.imerominia, v.typos, p.typos;