# Unified One-Pass Implementation Sequence

## 1. Governance inputs
Record:
- SharePoint site
- Power Platform environment
- monitoring/flow account
- Exchange administrator
- app admin emails
- AV support email
- Facilities support email
- issue escalation email
- business reporting hours
- check-in policy

## 2. Create all SharePoint lists
Use `01-SharePoint-Schema.md`.
Populate CRM_Settings and CRM_Admins.

## 3. Configure Exchange
Grant read access to room calendars.
Add room calendars to the monitoring account.
Verify calendar visibility.

## 4. Build CRM-01-SyncRoomDirectory
Run it manually first.
Complete room building/floor/capacity/amenity metadata.
Resolve CalendarId.

**Gate:** every production room must have valid RoomEmail and CalendarId.

## 5. Build CRM-02-RefreshRoomStatus
Test:
- Free
- Busy
- StartingSoon
- OutOfService
- Unknown

**Gate:** CRM_RoomStatus must contain exactly one row per room.

## 6. Build CRM-04 and CRM-05
Create feedback and issue intake notifications before exposing user forms.

## 7. Build CRM-06
Test overdue SLA escalation with a short temporary SLA in a non-production issue.

## 8. Build CRM-03
Generate:
- room-day metrics
- estate-day metric
- rolling room metrics

Reconcile 2–3 rooms manually against Outlook.

## 9. Build the canvas app shell
Create:
- scrDashboard
- scrRoomDetail
- scrFindRoom
- scrFeedback
- scrIssue
- scrReports
- scrAdmin

Add data sources and paste App.OnStart.

## 10. Build dashboard
Wire filters, KPIs, status gallery, refresh, navigation.

## 11. Build room detail/check-in
Wire current/next status fields and check-in formula.

## 12. Build feedback and issue screens
Test notifications end to end.

## 13. Build CRM-08-FindAvailableRooms
Add it to the app.
Wire find-room search and results gallery.

## 14. Build reporting
Use CRM_RoomRollingMetrics and CRM_EstateDailyMetrics.
Do not bind charts to unbounded CRM_RoomDailyMetrics.

## 15. Build admin
Gate UX with gblIsAdmin.
Enforce actual rights through SharePoint permissions.
Implement out-of-service, restore, issue resolution, flow health.

## 16. Build CRM-07-WeeklyOperationsReport
Use finalized metric fields and recipients.

## 17. Security/performance test
Run the complete checklist.

## 18. Production launch
Publish app, enable schedules, share to groups, monitor FlowLog and Unknown/stale statuses.
