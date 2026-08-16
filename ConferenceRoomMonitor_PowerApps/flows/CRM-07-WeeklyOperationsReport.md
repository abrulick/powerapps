# CRM-07-WeeklyOperationsReport

Trigger: Recurrence Monday at 07:30 local time.

## Window
Previous Monday through Sunday local time.

## Source
Use `CRM_EstateDailyMetrics` for headline totals and `CRM_RoomDailyMetrics` or `CRM_RoomRollingMetrics` for room ranking.

## Headline metrics
- Estate utilization %
- Total booked room-hours
- Meeting count
- Average feedback rating
- Low-rating count
- Issue count
- High/Critical issue count
- Inferred no-show count

## Room ranking
For a fixed previous-week report, calculate rankings from the seven room-day rows per room. Enable SharePoint pagination.

## Email
Office 365 Outlook — `Send an email (V2)`.

Sections:
1. Executive summary
2. Highest utilized rooms
3. Lowest utilized active rooms
4. Experience / feedback
5. Support / issues
6. Exceptions needing action
7. Link to the Power Apps reporting/admin screen
