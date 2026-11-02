# Data

The raw GTFS files are not stored in this repository.

- **Publisher:** Metropolitan Transit Authority of Harris County (METRO), http://www.ridemetro.org
- **Where to get it:** search "Houston METRO" on https://mobilitydatabase.org and download the latest GTFS schedule dataset
- **Version used:** `August2026IVOMS_20260828` (from `feed_info.txt`), valid 2026-08-30 to 2027-01-23

## Files

| File | Rows | Used in |
|---|---|---|
| agency.txt | 1 | Bronze only |
| calendar.txt | 6 | Silver (service-day filter) |
| calendar_dates.txt | 48 | Silver (holiday exceptions) |
| direction_names_exceptions.txt | 216 | Bronze only |
| fare_attributes.txt | 6 | Bronze only |
| fare_rules.txt | 120 | Bronze only |
| feed_info.txt | 1 | Bronze only (feed version) |
| routes.txt | 120 | Silver, Gold |
| shapes.txt | 229,660 | Bronze only |
| stop_times.txt | 1,415,650 | Silver, Gold |
| stops.txt | 8,797 | Silver, Gold |
| trips.txt | 21,878 | Silver, Gold |

A newer feed version will have different counts.
