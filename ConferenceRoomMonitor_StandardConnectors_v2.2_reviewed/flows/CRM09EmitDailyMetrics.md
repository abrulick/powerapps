# CRM09EmitDailyMetrics

Trigger: Recurrence daily after midnight local time.

Capability: **Enhanced Calendar Detail**

## Purpose

Create exact room-day booking and people-demand metrics.

## Security / connection

- room inventory is discovered server-side
- all calendar actions use the monitoring-account connection

## Local reporting window

Calculate the previous local reporting date using the configured Windows time zone.

Build business start/end as local wall-clock values and convert each boundary with `convertToUtc`.

Do not calculate this using the flow host's/user's local zone.

## Event rules

For each room:
1. resolve calendar by Owner.Address
2. get calendar view of events (V3)
3. page when required
4. apply occupied ShowAs policy
5. clip each interval to business window

## Overlap handling

Before summing booked minutes:
- sort intervals by start
- merge overlapping/adjacent occupied intervals
- sum merged duration

Also set `overlapDetected=true` if raw intervals overlap.

This prevents utilization above 100%.

## People demand

For each event calculate:
- InviteeCount
- PlannedPeople

using `docs/03-People-Demand.md`.

## Persist

Payload:
- room-day aggregates
- compact meeting-grain records with counts only

Send `[CRM-DAILY-METRICS] <metricDate>` to shared mailbox.

Power BI de-duplicates reruns by metricDate/room and keeps latest generatedUtc.
