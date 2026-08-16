With(
    {
        _duration: Value(ddFindDuration.Selected.Value),
        _localStart:
            Text(dpFindDate.SelectedDate, "[$-en-US]yyyy-mm-dd") &
            "T" &
            Text(
                Time(
                    Value(ddFindHour.Selected.Value),
                    Value(ddFindMinute.Selected.Value),
                    0
                ),
                "[$-en-US]hh:mm:ss"
            )
    },
    If(
        IsBlank(dpFindDate.SelectedDate) ||
        _duration <= 0,
        Notify(
            "Choose a valid date and duration.",
            NotificationType.Warning,
            3000
        ),

        CountRows(colRooms) > 100 &&
        Coalesce(ddFindRoomList.Selected.Value, "All") = "All",
        Notify(
            "Choose a room list to keep the availability search responsive.",
            NotificationType.Information,
            3500
        ),

        Set(gblFindBusy, true);

        IfError(
            Set(
                varFindResult,
                CRM04FindAvailableRooms.Run(
                    _localStart,
                    _duration,
                    gblDefaultTimeZoneName,
                    Coalesce(ddFindRoomList.Selected.Value, "All")
                )
            );

            ClearCollect(
                colAvailableRooms,
                ForAll(
                    Table(ParseJSON(Coalesce(varFindResult.availableRoomsJson, "[]"))),
                    {
                        RoomListName: Text(ThisRecord.Value.roomListName),
                        RoomName: Text(ThisRecord.Value.roomName),
                        RoomEmail: Lower(Text(ThisRecord.Value.roomEmail))
                    }
                )
            );

            Set(gblFindBusy, false),

            Clear(colAvailableRooms);
            Set(gblFindBusy, false);
            Notify(
                "Availability search failed. " & FirstError.Message,
                NotificationType.Error,
                5000
            )
        )
    )
)
