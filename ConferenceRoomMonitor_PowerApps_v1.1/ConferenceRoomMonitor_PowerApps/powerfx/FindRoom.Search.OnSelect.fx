// Add CRM-08-FindAvailableRooms to the app from the Power Automate pane.
// The exact generated flow identifier can differ; rename it in Studio to CRM08FindAvailableRooms.

Set(
    varFindStartUtc,
    DateAdd(
        DateValue(dpFindDate.SelectedDate) +
        Time(Value(ddFindHour.Selected.Value), Value(ddFindMinute.Selected.Value), 0),
        TimeZoneOffset(
            DateValue(dpFindDate.SelectedDate) +
            Time(Value(ddFindHour.Selected.Value), Value(ddFindMinute.Selected.Value), 0)
        ),
        TimeUnit.Minutes
    )
);

Set(
    varFindEndUtc,
    DateAdd(varFindStartUtc, Value(ddFindDuration.Selected.Value), TimeUnit.Minutes)
);

Set(
    varFindResult,
    CRM08FindAvailableRooms.Run(
        Text(varFindStartUtc, "[$-en-US]yyyy-mm-ddThh:mm:ssZ"),
        Text(varFindEndUtc, "[$-en-US]yyyy-mm-ddThh:mm:ssZ"),
        Coalesce(numFindCapacity.Value, 0),
        Coalesce(ddFindBuilding.Selected.Value, "All"),
        togFindTeamsRoom.Checked,
        togFindWhiteboard.Checked
    )
);

ClearCollect(
    colAvailableRoomEmails,
    ForAll(
        Split(Coalesce(varFindResult.availableRoomEmailsCsv, ""), ";"),
        {RoomEmail: Lower(Trim(Value))}
    )
);

ClearCollect(
    colAvailableRooms,
    Filter(
        colRooms As R,
        !IsBlank(
            LookUp(
                colAvailableRoomEmails As A,
                A.RoomEmail = Lower(R.RoomEmail),
                A.RoomEmail
            )
        )
    )
);

Notify(
    CountRows(colAvailableRooms) & " rooms available.",
    NotificationType.Information,
    2500
);
