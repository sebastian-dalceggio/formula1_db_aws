SELECT r.circuitid, r.name, r.year, AVG(l.milliseconds), TO_TIMESTAMP(AVG(l.milliseconds) / 1000.0)::TIME AS time
FROM laptimes l
LEFT JOIN races r ON (r.raceid = l.raceid)
GROUP BY r.circuitid, r.name, r.year