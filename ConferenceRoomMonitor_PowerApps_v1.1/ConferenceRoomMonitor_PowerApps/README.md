# Microsoft 365 Conference Room Monitor — Power Apps Implementation Kit

Version: 1.1  
Architecture: Power Apps Canvas + SharePoint + Office 365 Outlook + Power Automate  
Primary mode: Standard Microsoft 365 connectors; no PCF required.

## What this solution delivers

- Live room status dashboard: Free / Busy / Starting Soon / Out of Service / Unknown
- Building, floor, capacity, amenity, and text filters
- Current and next booking windows
- Today's room status/detail experience
- Future-slot "Find a room" availability flow
- User check-in
- Inferred no-show reporting based on optional check-in policy
- 1–5 room rating and written feedback
- AV / display / camera / microphone / connectivity / furniture / cleanliness / HVAC issue reporting
- Issue ownership, severity, SLA targets, escalation, and resolution tracking
- Scalable utilization reporting based on daily and rolling aggregate caches
- 7/30/90-day room utilization comparison
- Daily estate utilization/experience/support trend
- Weekly facilities/AV operations summary email
- Admin controls for room service state, issues, feedback, flow health, and settings
- Privacy-conscious reporting without storing meeting bodies, attendee lists, or historical subjects

## Important handoff note

This kit is intentionally delivered as an implementation package rather than a fabricated `.msapp`.

A production canvas app must bind to your tenant-specific SharePoint lists, Office 365 Outlook connection, Power Automate flows, and connection references. Microsoft also documents that generated `.pa.yaml` source is not a general-purpose hand-authored import surface, while `pac canvas pack/unpack` is preview/deprecated for source-control workflows. The reliable deployment path is therefore:

1. Create the tenant data/flow dependencies.
2. Create a responsive canvas app in your environment.
3. Add the named data sources.
4. Create the screen/control tree from the build guide.
5. Paste the supplied Power Fx formulas into the mapped properties.

This avoids delivering an `.msapp` that opens with broken or foreign connection references.

## SharePoint lists

- CRM_Rooms
- CRM_RoomStatus
- CRM_RoomDailyMetrics
- CRM_RoomRollingMetrics
- CRM_EstateDailyMetrics
- CRM_CheckIns
- CRM_Feedback
- CRM_Issues
- CRM_Settings
- CRM_Admins
- CRM_FlowLog

## Power Automate flows

- CRM-01-SyncRoomDirectory
- CRM-02-RefreshRoomStatus
- CRM-03-DailyMetricsAndReportCaches
- CRM-04-FeedbackNotification
- CRM-05-IssueIntakeNotification
- CRM-06-IssueSLAEscalation
- CRM-07-WeeklyOperationsReport
- CRM-08-FindAvailableRooms

## One-pass implementation order

1. `docs/00-Architecture.md`
2. `docs/01-SharePoint-Schema.md`
3. `docs/02-Exchange-Prerequisites.md`
4. Create flows from `flows/` in numeric order.
5. `docs/04-PowerApps-Build.md`
6. `docs/09-Control-Property-Map.md`
7. Paste formulas from `powerfx/`.
8. `docs/05-Reporting-KPIs.md`
9. `docs/06-Security-Privacy.md`
10. `docs/07-Test-Deployment.md`
11. `docs/08-Operations-Runbook.md`
12. `docs/10-Implementation-Sequence.md`

## Naming rule

Do not rename data sources after pasting formulas unless you update every reference. If your governance standard requires a different prefix, rename consistently before you start building the app.
