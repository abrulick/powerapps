Set(gblUserEmail, Lower(User().Email));
Set(gblUserName, User().FullName);
Set(gblNowUtc, DateAdd(Now(), TimeZoneOffset(Now()), TimeUnit.Minutes));

ClearCollect(
    colSettings,
    ShowColumns(
        CRM_Settings,
        Title,
        SettingValue,
        SettingNumber,
        SettingBoolean
    )
);

Set(
    gblStartingSoonMinutes,
    Coalesce(LookUp(colSettings, Title = "StartingSoonMinutes", SettingNumber), 15)
);
Set(
    gblStatusStaleMinutes,
    Coalesce(LookUp(colSettings, Title = "StatusStaleMinutes", SettingNumber), 12)
);
Set(
    gblCheckInGraceMinutes,
    Coalesce(LookUp(colSettings, Title = "CheckInGraceMinutes", SettingNumber), 10)
);

Set(
    gblIsAdmin,
    !IsBlank(
        LookUp(
            CRM_Admins,
            Lower(Title) = gblUserEmail && IsActive = true,
            ID
        )
    )
);

Concurrent(
    Refresh(CRM_Rooms),
    Refresh(CRM_RoomStatus),
    Refresh(CRM_RoomRollingMetrics),
    Refresh(CRM_EstateDailyMetrics),
    Refresh(CRM_Issues),
    Refresh(CRM_Feedback)
);

ClearCollect(colRooms, Filter(CRM_Rooms, IsActive = true));
ClearCollect(colRoomStatus, CRM_RoomStatus);

ClearCollect(colBuildingOptions, {Value: "All"});
Collect(
    colBuildingOptions,
    Sort(
        Distinct(
            Filter(colRooms, !IsBlank(Building.Value)),
            Building.Value
        ),
        Value,
        SortOrder.Ascending
    )
);

ClearCollect(colFloorOptions, {Value: "All"});
Collect(
    colFloorOptions,
    Sort(
        Distinct(Filter(colRooms, !IsBlank(Floor)), Floor),
        Value,
        SortOrder.Ascending
    )
);

ClearCollect(
    colCapacityOptions,
    {Value: "Any", MinCapacity: 0},
    {Value: "4+", MinCapacity: 4},
    {Value: "6+", MinCapacity: 6},
    {Value: "8+", MinCapacity: 8},
    {Value: "10+", MinCapacity: 10},
    {Value: "12+", MinCapacity: 12},
    {Value: "16+", MinCapacity: 16},
    {Value: "20+", MinCapacity: 20}
);

Set(gblLastRefreshLocal, Now());
