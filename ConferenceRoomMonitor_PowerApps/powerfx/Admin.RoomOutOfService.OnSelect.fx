If(
    !gblIsAdmin,
    Notify("You are not authorized for this action.", NotificationType.Error, 3000),
    IfError(
        Patch(
            CRM_Rooms,
            LookUp(CRM_Rooms, ID = galAdminRooms.Selected.ID),
            {
                OutOfService: true,
                OutOfServiceReason: Trim(txtOutOfServiceReason.Text)
            }
        ),
        Notify("Could not update room.", NotificationType.Error, 4000),
        Refresh(CRM_Rooms);
        Notify("Room marked out of service.", NotificationType.Success, 2500)
    )
)
