SELECT r.constructorid, c.name, c.nationality, COUNT(*) AS wins
FROM results r
LEFT JOIN constructors c ON (c.constructorid = r.constructorid)
WHERE position = 1
GROUP BY r.constructorid, c.name, c.nationality
ORDER BY wins DESC