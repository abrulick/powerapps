If(
    IsBlank(gblSelectedRoomStatus.CurrentStartUtc),
    Notify("There is no active booking to check into.", NotificationType.Warning, 3000),
    With(
        {
            _key:
                Lower(gblSelectedRoom.RoomEmail) & "|" &
                Text(gblSelectedRoomStatus.CurrentStartUtc, "[$-en-US]yyyy-mm-ddThh:mm:ss") & "|" &
                gblUserEmail
        },
        If(
            !IsBlank(LookUp(CRM_CheckIns, CheckInKey = _key, ID)),
            Notify("You are already checked in.", NotificationType.Information, 2500),
            IfError(
                Patch(
                    CRM_CheckIns,
                    Defaults(CRM_CheckIns),
                    {
                        Title: gblSelectedRoom.Title & " check-in",
                        CheckInKey: _key,
                        RoomEmail: Lower(gblSelectedRoom.RoomEmail),
                        BookingStartUtc: gblSelectedRoomStatus.CurrentStartUtc,
                        BookingEndUtc: gblSelectedRoomStatus.CurrentEndUtc,
                        CheckInUtc: gblNowUtc,
                        CheckedInBy: {
                            '@odata.type': "#Microsoft.Azure.Connectors.SharePoint.SPListExpandedUser",
                            Claims: "i:0#.f|membership|" & gblUserEmail,
                            DisplayName: gblUserName,
                            Email: gblUserEmail
                        },
                        CheckInMethod: {Value: "PowerApp"}
                    }
                ),
                Notify("Check-in failed. Please try again.", NotificationType.Error, 4000),
                Notify("Checked in.", NotificationType.Success, 2500)
            )
        )
    )
)
