Refresh(CRM_RoomStatus);
Set(
    gblSelectedRoomStatus,
    LookUp(CRM_RoomStatus, Lower(RoomEmail) = Lower(gblSelectedRoom.RoomEmail))
);

Set(gblNowUtc, DateAdd(Now(), TimeZoneOffset(Now()), TimeUnit.Minutes));
