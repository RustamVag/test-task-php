SELECT
    r.number              AS route_number,
    dest.name             AS destination,
    bss.expected_arrival_time,
    b.registration_number,
    b.model
FROM bus_schedule_stops AS bss
JOIN bus_schedules AS bs ON bs.id = bss.bus_schedule_id
JOIN routes AS r         ON r.id = bs.route_id
JOIN cities AS dest      ON dest.id = r.destination_city_id
JOIN buses AS b          ON b.id = bs.bus_id
WHERE bss.city_id = ?
  AND bss.expected_arrival_time >= NOW()
  AND bss.city_id <> r.destination_city_id
ORDER BY bss.expected_arrival_time
LIMIT 15;