Set(gblAppVersion, "2.2");
Set(gblDefaultTimeZoneName, "REPLACE_ME");
Set(gblPowerBIUrl, "REPLACE_ME");
Set(gblStartingSoonMinutes, 15);
Set(gblStatusFreshnessMinutes, 12);
Set(gblStatusRefreshSeconds, 600);
Set(gblInventoryBusy, true);
Set(gblInventoryLoadFailed, false);
Set(gblNeedsStatusRefresh, true);

IfError(
    Set(varInventoryResult, CRM01DiscoverRoomInventory.Run());

    ClearCollect(
        colRooms,
        ForAll(
            Table(ParseJSON(Coalesce(varInventoryResult.roomsJson, "[]"))),
            {
                RoomListName: Text(ThisRecord.Value.roomListName),
                RoomListAddress: Lower(Text(ThisRecord.Value.roomListAddress)),
                RoomName: Text(ThisRecord.Value.roomName),
                RoomEmail: Lower(Text(ThisRecord.Value.roomEmail))
            }
        )
    );

    ClearCollect(colRoomListOptions, {Value: "All"});
    Collect(
        colRoomListOptions,
        Sort(
            Distinct(colRooms, RoomListName),
            Value,
            SortOrder.Ascending
        )
    );

    Set(gblLastInventoryRefresh, Now());
    Set(gblInventoryBusy, false),

    Clear(colRooms);
    ClearCollect(colRoomListOptions, {Value: "All"});
    Set(gblInventoryLoadFailed, true);
    Set(gblInventoryBusy, false);
    Notify(
        "Room inventory could not be loaded. " & FirstError.Message,
        NotificationType.Error,
        5000
    )
);
