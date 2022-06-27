SELECT d.driverid, d.forename, d.surname, d.nationality, COUNT(*) AS fastestlaps
FROM(
  SELECT r.circuitid, MIN(l1.milliseconds) AS mintime
  FROM laptimes l1
  LEFT JOIN races r ON (r.raceid = l1.raceid)
  GROUP BY r.circuitid
  LIMIT 10) l2
LEFT JOIN laptimes l3 ON (l3.milliseconds = l2.mintime)
LEFT JOIN drivers d ON (d.driverid = l3.driverid)
GROUP BY d.driverid, d.forename, d.surname, d.nationality
ORDER BY fastestlaps DESC