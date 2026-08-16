# Power Apps Canvas Build

## App type
Responsive tablet/desktop canvas app.

Recommended:
- Scale to fit: Off
- Lock aspect ratio: Off
- Modern controls: On if approved
- Modern theme: On if approved
- Use modern Text Input `.Text` and Toggle `.Checked` properties
- Use classic chart controls if you want the most established chart surface

## Data sources

Add:
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
- Office 365 Outlook
- Office 365 Users (optional)
- CRM-08-FindAvailableRooms Power Automate flow

Rename the flow reference in Power Apps Studio to `CRM08FindAvailableRooms` if necessary so the supplied formula is stable.

## Screen tree

### scrDashboard
- cmbBuilding — Items `colBuildingOptions`
- cmbFloor — Items `colFloorOptions`
- cmbCapacity — Items `colCapacityOptions`
- txtRoomSearch
- togAvailableOnly
- galRooms
- KPI room status cards
- refresh/find/reports/admin navigation

`btnAdmin.Visible = gblIsAdmin`

### scrRoomDetail
- room identity, location, capacity, amenities
- current room status
- current booking start/end
- next booking start/end
- check-in
- feedback
- issue report

### scrFindRoom
Inputs:
- dpFindDate
- ddFindHour
- ddFindMinute
- ddFindDuration
- numFindCapacity
- ddFindBuilding
- togFindTeamsRoom
- togFindWhiteboard

Results:
- galAvailableRooms -> `colAvailableRooms`

Search button:
- use `powerfx/FindRoom.Search.OnSelect.fx`

This flow queries each candidate room's calendar for the requested future slot.

### scrFeedback
- 1–5 rating selector
- category
- comment
- anonymous toggle
- follow-up toggle
- submit

### scrIssue
- category
- severity
- description
- submit

### scrReports
Range selector:
- 7 days
- 30 days
- 90 days

Visuals:
- room utilization comparison from `colUtilizationByRoom`
- estate utilization trend from `colEstateTrend`
- KPI cards
- rating distribution using `CRM_EstateDailyMetrics` rating-count fields
- support trend using daily IssueCount / HighCriticalIssueCount

### scrAdmin
`Visible`/navigation gated by `gblIsAdmin`, plus SharePoint permission enforcement.

Tabs:
- Rooms
- Open issues
- Feedback
- Flow health
- Settings

Functions:
- mark room out of service
- restore room
- edit metadata
- resolve issue
- review feedback
- inspect stale room status / flow failures

## Responsive layout

Use auto-layout containers. Suggested:
- desktop: filter rail + content grid
- narrow: filters above room gallery
- dashboard gallery template should wrap to 1–3 columns based on available width

## Accessibility

- meaningful AccessibleLabel on status/action controls
- do not rely on color alone for Free/Busy
- preserve keyboard focus order
- use semantic headings where supported
- visible error/success notifications
