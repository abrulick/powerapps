Set(gblNowUtc, DateAdd(Now(), TimeZoneOffset(Now()), TimeUnit.Minutes));

Concurrent(
    Refresh(CRM_RoomStatus),
    Refresh(CRM_Rooms)
);

ClearCollect(
    colRooms,
    Filter(CRM_Rooms, IsActive = true)
);
ClearCollect(colRoomStatus, CRM_RoomStatus);

Set(gblLastRefreshLocal, Now());
