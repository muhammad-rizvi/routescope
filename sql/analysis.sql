-- MetroPulse: SQL analysis on the gold tables
-- Service day: Wednesday, 2026-11-04 (METRO GTFS feed August2026IVOMS_20260828)

USE workspace.metropulse;

-- Q1. Network overview
SELECT
  COUNT(*)                                          AS routes_running,
  SUM(weekday_trips)                                AS weekday_trips,
  (SELECT COUNT(*) FROM gold_stop_summary)          AS stops_served,
  SUM(CASE WHEN frequent_midday THEN 1 ELSE 0 END)  AS frequent_routes
FROM gold_route_summary;

-- Q2. Top 10 routes by weekday trips
SELECT route_short_name, route_long_name, mode, weekday_trips, stops_served, midday_headway_min
FROM gold_route_summary
ORDER BY weekday_trips DESC
LIMIT 10;

-- Q3. Share of weekday trips run by the top 10 routes
WITH ranked AS (
  SELECT route_long_name, weekday_trips,
         ROW_NUMBER() OVER (ORDER BY weekday_trips DESC) AS rnk
  FROM gold_route_summary
)
SELECT
  SUM(CASE WHEN rnk <= 10 THEN weekday_trips END)                                        AS top10_trips,
  SUM(weekday_trips)                                                                     AS all_trips,
  ROUND(100.0 * SUM(CASE WHEN rnk <= 10 THEN weekday_trips END) / SUM(weekday_trips), 1) AS top10_pct
FROM ranked;

-- Q4. Biggest transfer hubs (stops served by the most routes)
SELECT stop_name, routes_served, weekday_departures
FROM gold_stop_summary
ORDER BY routes_served DESC, weekday_departures DESC
LIMIT 10;

-- Q5. Trips started by hour of day, bus vs rail
SELECT start_hour, mode, SUM(trips_started) AS trips_started
FROM gold_hourly_service
GROUP BY start_hour, mode
ORDER BY start_hour, mode;

-- Q6. Routes running every 15 minutes or better at midday (10 AM - 2 PM)
SELECT route_short_name, route_long_name, mode, midday_headway_min
FROM gold_route_summary
WHERE frequent_midday
ORDER BY midday_headway_min, route_short_name;

-- Q7. Routes serving the most stops
SELECT route_short_name, route_long_name, stops_served, avg_trip_minutes
FROM gold_route_summary
ORDER BY stops_served DESC
LIMIT 10;

-- Q8. Share of stops served by at least one frequent route
SELECT
  COUNT(DISTINCT e.stop_id)                                             AS stops_served,
  COUNT(DISTINCT CASE WHEN r.frequent_midday THEN e.stop_id END)        AS stops_with_frequent_service,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN r.frequent_midday THEN e.stop_id END)
        / COUNT(DISTINCT e.stop_id), 1)                                 AS pct_frequent
FROM silver_stop_events e
JOIN gold_route_summary r ON e.route_id = r.route_id;
