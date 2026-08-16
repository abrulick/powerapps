If(
    !gblInventoryBusy,
    Set(gblInventoryBusy, true);

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
        Set(gblInventoryBusy, false);
        Set(gblNeedsStatusRefresh, true);
        Select(btnRefreshStatus),

        Set(gblInventoryBusy, false);
        Notify(
            "Room inventory could not be refreshed. " & FirstError.Message,
            NotificationType.Error,
            5000
        )
    )
);
