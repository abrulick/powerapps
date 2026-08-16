# Power Apps Control / Property Map

## App
- OnStart -> `powerfx/App.OnStart.fx`
- OnError -> `powerfx/App.OnError.fx`
- StartScreen -> `scrDashboard`

## scrDashboard
- OnVisible -> `powerfx/scrDashboard.OnVisible.fx`
- cmbRoomList.Items -> `colRoomListOptions`
- cmbStatus.Items ->
```powerfx
Table(
    {Value:"All"},
    {Value:"Free"},
    {Value:"Busy"},
    {Value:"StartingSoon"},
    {Value:"Unknown"}
)
```
- txtRoomSearch -> modern Text Input
- galRooms.Items -> `powerfx/galRooms.Items.fx`
- btnRefreshInventory.OnSelect -> `powerfx/btnRefreshInventory.OnSelect.fx`
- btnRefreshStatus.OnSelect -> `powerfx/btnRefreshStatus.OnSelect.fx`
- tmrStatusRefresh.Duration -> `600000`
- tmrStatusRefresh.AutoStart -> `true`
- tmrStatusRefresh.Repeat -> `true`
- tmrStatusRefresh.OnTimerEnd -> `powerfx/tmrStatusRefresh.OnTimerEnd.fx`
- room-card open -> `powerfx/Room.OpenDetail.OnSelect.fx`
- status label -> `powerfx/RoomStatus.Display.fx`

## scrRoomDetail
- OnVisible -> `powerfx/scrRoomDetail.OnVisible.fx`
- galDayEvents.Items -> `colRoomDayEvents`

Suggested detail-availability message:
```powerfx
If(
    gblRoomDetailAvailable,
    "",
    "Detailed calendar data is not enabled for this room."
)
```

## scrFindRoom
Controls required:
- dpFindDate
- ddFindHour
- ddFindMinute
- ddFindDuration
- ddFindRoomList
- btnFind
- galAvailableRooms

- btnFind.OnSelect -> `powerfx/FindRoom.Search.OnSelect.fx`
- galAvailableRooms.Items -> `colAvailableRooms`

## scrFeedback
Controls:
- cmbFeedbackCategory
- txtFeedbackComment
- togAnonymous
- btnSubmitFeedback

btnSubmitFeedback.OnSelect -> `powerfx/Feedback.Submit.OnSelect.fx`
btnSubmitFeedback.DisplayMode ->
```powerfx
If(gblFeedbackBusy, DisplayMode.Disabled, DisplayMode.Edit)
```

## scrIssue
Controls:
- cmbIssueSeverity
- cmbIssueCategory
- txtIssueDescription
- btnSubmitIssue

btnSubmitIssue.OnSelect -> `powerfx/Issue.Submit.OnSelect.fx`
btnSubmitIssue.DisplayMode ->
```powerfx
If(gblIssueBusy, DisplayMode.Disabled, DisplayMode.Edit)
```

## scrReports
- btnOpenPowerBI.OnSelect -> `powerfx/Reports.Open.OnSelect.fx`
