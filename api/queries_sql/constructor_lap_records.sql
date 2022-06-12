SELECT c.constructorid, c.name, c.nationality, COUNT(*) AS fastestlaps
FROM(
  SELECT r.circuitid, MIN(l1.milliseconds) AS mintime
  FROM laptimes l1
  LEFT JOIN races r ON (r.raceid = l1.raceid)
  GROUP BY r.circuitId
  LIMIT 10) l2
LEFT JOIN laptimes l3 ON (l3.milliseconds = l2.mintime)
LEFT JOIN races ra ON (ra.raceid = l3.raceid)
LEFT JOIN results re ON (re.raceid = l3.raceid AND re.driverid = l3.driverid)
LEFT JOIN constructors c ON (c.constructorid = re.constructorid)
GROUP BY c.constructorid, c.name, c.nationality
ORDER BY fastestlaps DESC