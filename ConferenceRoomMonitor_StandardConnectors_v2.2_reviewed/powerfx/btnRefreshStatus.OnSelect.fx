If(
    !gblStatusBusy,
    Set(gblStatusBusy, true);

    IfError(
        Set(
            varStatusResult,
            CRM03GetRoomStatusCache.Run(gblStatusFreshnessMinutes)
        );

        Set(
            gblStatusSnapshotUtc,
            If(
                IsBlank(varStatusResult.snapshotUtc),
                Blank(),
                DateTimeValue(varStatusResult.snapshotUtc)
            )
        );

        ClearCollect(
            colRoomStatus,
            ForAll(
                Table(ParseJSON(Coalesce(varStatusResult.statusJson, "[]"))),
                {
                    RoomEmail: Lower(Text(ThisRecord.Value.roomEmail)),
                    Status: Text(ThisRecord.Value.status),
                    Availability: Text(ThisRecord.Value.availability),
                    SnapshotUtc: gblStatusSnapshotUtc,
                    ErrorText: Text(ThisRecord.Value.error)
                }
            )
        );

        ClearCollect(
            colRoomView,
            ForAll(
                colRooms As R,
                With(
                    {
                        _s: LookUp(
                            colRoomStatus,
                            RoomEmail = R.RoomEmail
                        )
                    },
                    {
                        RoomListName: R.RoomListName,
                        RoomListAddress: R.RoomListAddress,
                        RoomName: R.RoomName,
                        RoomEmail: R.RoomEmail,
                        LiveStatus: Coalesce(_s.Status, "Unknown"),
                        Availability: Coalesce(_s.Availability, "unknown"),
                        SnapshotUtc: _s.SnapshotUtc,
                        ErrorText: Coalesce(_s.ErrorText, "")
                    }
                )
            )
        );

        Set(gblStatusStale, Coalesce(varStatusResult.stale, true));
        Set(gblLastStatusRefresh, Now());
        Set(gblNeedsStatusRefresh, false);
        Set(gblStatusBusy, false),

        Set(gblStatusStale, true);
        Set(gblNeedsStatusRefresh, true);
        Set(gblStatusBusy, false);
        Notify(
            "Room status could not be refreshed. " & FirstError.Message,
            NotificationType.Error,
            5000
        )
    )
);
