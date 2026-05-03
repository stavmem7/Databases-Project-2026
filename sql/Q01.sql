SELECT 
    t.onoma AS tmima,
    YEAR(n.im_eisagogis) AS etos,
    n.kwdikos_KEN,
    k.vasiko_kostos,
    COUNT(n.nosileia_id) AS plithos_nosilion,
    SUM(k.vasiko_kostos) AS synoliko_vasiko,
    SUM(n.synoliko_kostos - k.vasiko_kostos) AS prostheti_xrewsi,
    SUM(n.synoliko_kostos) AS synolika_esoda,
    a.asfalistikos_foreas,
    COUNT(a.AMKA) AS plithos_ana_forea
FROM nosileia n
JOIN tmima t ON n.tmima_id = t.tmima_id
JOIN ken k ON n.kwdikos_KEN = k.kwdikos_KEN
JOIN asthenis a ON n.AMKA_astheni = a.AMKA
GROUP BY t.tmima_id, YEAR(n.im_eisagogis), n.kwdikos_KEN, a.asfalistikos_foreas
ORDER BY etos, tmima, n.kwdikos_KEN;