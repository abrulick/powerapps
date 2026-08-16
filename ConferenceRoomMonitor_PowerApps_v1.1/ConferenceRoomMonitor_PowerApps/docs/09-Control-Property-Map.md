# Control / Property Map

| Screen | Control | Property | Formula/source |
|---|---|---|---|
| App | App | OnStart | `powerfx/App.OnStart.fx` |
| scrDashboard | cmbBuilding | Items | `colBuildingOptions` |
| scrDashboard | cmbBuilding | OnChange | `powerfx/cmbBuilding.OnChange.fx` |
| scrDashboard | cmbFloor | Items | `colFloorOptions` |
| scrDashboard | cmbCapacity | Items | `colCapacityOptions` |
| scrDashboard | galRooms | Items | `powerfx/galRooms.Items.fx` |
| scrDashboard | btnRefresh | OnSelect | `powerfx/btnRefresh.OnSelect.fx` |
| scrDashboard | btnAdmin | Visible | `gblIsAdmin` |
| scrRoomDetail | btnCheckIn | OnSelect | `powerfx/btnCheckIn.OnSelect.fx` |
| scrFindRoom | btnSearch | OnSelect | `powerfx/FindRoom.Search.OnSelect.fx` |
| scrFindRoom | galAvailableRooms | Items | `colAvailableRooms` |
| scrFeedback | btnSubmitFeedback | OnSelect | `powerfx/Feedback.Submit.OnSelect.fx` |
| scrIssue | btnSubmitIssue | OnSelect | `powerfx/Issue.Submit.OnSelect.fx` |
| scrReports | btnLoadReport | OnSelect | `powerfx/Reports.Load.fx` |
| scrAdmin | btnOutOfService | OnSelect | `powerfx/Admin.RoomOutOfService.OnSelect.fx` |
| scrAdmin | btnRestore | OnSelect | `powerfx/Admin.RestoreRoom.OnSelect.fx` |
| scrAdmin | btnResolveIssue | OnSelect | `powerfx/Admin.ResolveIssue.OnSelect.fx` |

## Report chart bindings

Room-utilization column chart:
- Items: `SortByColumns(colUtilizationByRoom, "Utilization", SortOrder.Descending)`
- Category/label: `RoomName`
- Value: `Utilization`

Estate trend line chart:
- Items: `SortByColumns(colEstateTrend, "MetricDate", SortOrder.Ascending)`
- Category/label: `MetricDate`
- Value: `UtilizationPct`

## Suggested issue galleries

Open issues:
```powerfx
SortByColumns(
    Filter(
        CRM_Issues,
        Status.Value <> "Resolved" &&
        Status.Value <> "Closed"
    ),
    "CreatedUtc",
    SortOrder.Descending
)
```

Stale room statuses:
```powerfx
Filter(
    CRM_RoomStatus,
    Status.Value = "Unknown" ||
    DateDiff(SnapshotUtc, gblNowUtc, TimeUnit.Minutes) > gblStatusStaleMinutes
)
```
