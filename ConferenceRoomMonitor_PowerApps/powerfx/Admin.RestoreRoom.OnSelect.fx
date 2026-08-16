IfError(
    Patch(
        CRM_Rooms,
        LookUp(CRM_Rooms, ID = galAdminRooms.Selected.ID),
        {
            OutOfService: false,
            OutOfServiceReason: Blank()
        }
    ),
    Notify("Could not update room.", NotificationType.Error, 4000),
    Refresh(CRM_Rooms);
    Notify("Room restored.", NotificationType.Success, 2500)
)
