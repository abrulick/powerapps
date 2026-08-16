# Power Apps Build

## Flows added to the app

Use exact flow names:
- CRM01DiscoverRoomInventory
- CRM03GetRoomStatusCache
- CRM04FindAvailableRooms
- CRM05GetRoomDayDetail
- CRM06SubmitFeedback
- CRM07SubmitIssue

Scheduled flows are not added to the app:
- CRM02RefreshRoomStatusCache
- CRM08EmitAvailabilitySnapshot
- CRM09EmitDailyMetrics

## Runtime collections

- colRooms
- colRoomStatus
- colRoomView
- colRoomListOptions
- colAvailableRooms
- colRoomDayEvents

## App startup

`App.OnStart`:
- initializes config
- dynamically discovers room inventory
- sets a flag requesting a status refresh

It does **not** Select a dashboard button.

`scrDashboard.OnVisible`:
- if status is missing/stale, selects `btnRefreshStatus` on the same screen.

## Dashboard

Default card shows:
- RoomName
- RoomListName
- Status
- status freshness

Baseline deliberately does not show exact Busy-until/Next-start because doing that for every room would require detailed calendar reads.

## Room detail

`CRM05GetRoomDayDetail` is Enhanced.

If Enhanced is unavailable:
- screen still shows baseline status
- show "Detailed calendar data is not enabled"
- feedback/issue actions remain available

## Time zones

Do not convert selected meeting times using the user's `TimeZoneOffset`.

Pass:
- local date/time text
- `gblDefaultTimeZoneName`

to the flow. The flow converts to UTC.

## Error handling

Enable formula-level error management and use `IfError`.

Every flow-backed button should:
1. validate input
2. set busy flag
3. invoke flow inside `IfError`
4. clear busy flag in both success/error paths
5. never expose secrets/raw connector payloads
