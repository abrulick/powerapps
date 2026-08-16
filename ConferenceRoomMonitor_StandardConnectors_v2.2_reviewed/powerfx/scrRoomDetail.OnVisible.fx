Set(gblRoomDetailBusy, true);
Set(gblRoomDetailAvailable, false);
Clear(colRoomDayEvents);

IfError(
    Set(
        varRoomDayResult,
        CRM05GetRoomDayDetail.Run(
            gblSelectedRoom.RoomEmail,
            "TODAY",
            gblDefaultTimeZoneName
        )
    );

    Set(
        gblRoomDetailAvailable,
        Coalesce(varRoomDayResult.detailAvailable, false)
    );

    If(
        gblRoomDetailAvailable,
        ClearCollect(
            colRoomDayEvents,
            ForAll(
                Table(ParseJSON(Coalesce(varRoomDayResult.eventsJson, "[]"))),
                {
                    StartUtc: DateTimeValue(Text(ThisRecord.Value.startUtc)),
                    EndUtc: DateTimeValue(Text(ThisRecord.Value.endUtc)),
                    InviteeCount: Value(ThisRecord.Value.inviteeCount),
                    PlannedPeople: Value(ThisRecord.Value.plannedPeople)
                }
            )
        )
    );

    Set(gblRoomDetailBusy, false),

    Set(gblRoomDetailAvailable, false);
    Set(gblRoomDetailBusy, false);
    Notify(
        "Detailed room data is unavailable. " & FirstError.Message,
        NotificationType.Warning,
        4000
    )
);
