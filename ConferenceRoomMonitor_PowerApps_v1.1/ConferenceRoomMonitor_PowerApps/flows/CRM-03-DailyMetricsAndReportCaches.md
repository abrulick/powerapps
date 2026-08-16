# CRM-03-DailyMetricsAndReportCaches

Trigger: Recurrence daily at 01:30 local time.

## Purpose

1. Create/update yesterday's `CRM_RoomDailyMetrics` row for each active room.
2. Create/update one `CRM_EstateDailyMetrics` row for yesterday.
3. Refresh one `CRM_RoomRollingMetrics` row per room for 7/30/90-day comparison.

## A. Room-day calculation

For each active room:

1. Build previous local day business-window start/end.
2. `Get calendar view of events (V3)` for that room CalendarId.
3. Page with Top/Skip if necessary. The connector has a maximum of 256 events per response.
4. Clip event intervals to business hours.
5. Exclude canceled/free events according to your tenant's event fields/policy.
6. Calculate:
   - AvailableMinutes
   - BookedMinutes
   - UtilizationPct
   - MeetingCount
   - AvgMeetingMinutes
   - PeakHour
7. Read room/day check-ins:
   - CheckedInMeetings
   - InferredNoShows under the approved check-in eligibility rule
8. Read room/day feedback:
   - FeedbackCount
   - RatingSum
   - AvgRating
   - Rating1Count...Rating5Count
9. Read room/day issues:
   - IssueCount
   - HighCriticalIssueCount
10. Upsert by MetricKey.

### Important overlap rule
Room mailboxes normally reject conflicting reservations. If your resource policy allows overlaps, merge intervals before summing BookedMinutes to avoid utilization over 100%.

## B. Estate-day cache

After all room rows are up to date:

1. Get `CRM_RoomDailyMetrics` for yesterday.
2. Sum numeric measures.
3. Calculate UtilizationPct and AvgRating from totals.
4. Upsert one `CRM_EstateDailyMetrics` row by MetricDate.

## C. Rolling room cache

For each active room:

1. Get the room's `CRM_RoomDailyMetrics` for the last 90 days with pagination enabled.
2. Calculate:
   - 7d utilization, booked hours, meeting count
   - 30d utilization, booked hours, meeting count
   - 90d utilization, booked hours, meeting count
   - 30d average rating and feedback count
   - 30d issue count
   - 30d inferred no-shows
3. Upsert `CRM_RoomRollingMetrics` by RoomEmail.

## Why this cache exists
Power Fx `GroupBy`, `ClearCollect`, and other client-side operations can hit the 500/2,000 nondelegation boundary. The rolling/estate caches keep report reads small regardless of the raw room-day history size.
