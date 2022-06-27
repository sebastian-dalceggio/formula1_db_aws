SELECT r.year, AVG(p.milliseconds), TO_TIMESTAMP(AVG(p.milliseconds) / 1000.0)::TIME AS time
FROM pitstops p
LEFT JOIN races r ON (r.raceid = p.raceid)
GROUP BY r.year