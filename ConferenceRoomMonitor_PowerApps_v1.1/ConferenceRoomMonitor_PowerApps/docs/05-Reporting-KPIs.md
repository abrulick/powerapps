# Reporting and KPIs

## Why the reporting cache is important

Power Apps can delegate many SharePoint filters, but client-side grouping/collection patterns can still hit the 500/2,000 nondelegation boundary. The solution therefore writes:

- one `CRM_RoomRollingMetrics` row per room
- one `CRM_EstateDailyMetrics` row per day

The reporting screen can remain small and predictable even if `CRM_RoomDailyMetrics` contains tens of thousands of rows.

## Room utilization
`BookedMinutes / AvailableMinutes * 100`

Use your configured business window unless rooms truly operate 24/7.

## Report surfaces

### Room comparison — 7/30/90 days
Source: `CRM_RoomRollingMetrics`

Fields:
- Utilization7d / 30d / 90d
- BookedHours7d / 30d / 90d
- MeetingCount7d / 30d / 90d

### Estate trend
Source: `CRM_EstateDailyMetrics`

Show:
- daily UtilizationPct
- BookedMinutes
- MeetingCount
- AvgRating
- IssueCount
- HighCriticalIssueCount
- InferredNoShows

### Rating distribution
Sum Rating1Count ... Rating5Count from the selected estate-day rows.

## Experience KPIs
- Average rating = total RatingSum / total FeedbackCount
- Feedback count
- % low ratings = (Rating1 + Rating2) / FeedbackCount
- rooms with low 30-day AvgRating

## Support KPIs
- Issue count
- High/Critical issue count
- Open issue count from CRM_Issues
- Overdue issue count from CRM_Issues
- MTTR can be calculated in a dedicated support report from ResolvedUtc - CreatedUtc

## Check-in KPI
Call it **Inferred No-Show**, never "no-show" without qualification.

Lack of app check-in may mean:
- no one checked in
- the organizer didn't know about check-in
- the meeting happened anyway
- the room was actually unused

## Optional Power BI
Power BI can consume the same aggregate lists if approved/licensed, but it is not required for this implementation.
