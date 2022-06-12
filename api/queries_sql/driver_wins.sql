SELECT r.driverId, d.forename, d.surname, d.nationality, COUNT(*) AS wins
FROM results r
LEFT JOIN drivers d ON (d.driverId = r.driverId)
WHERE position = 1
GROUP BY r.driverId, d.forename, d.surname, d.nationality
ORDER BY wins DESC