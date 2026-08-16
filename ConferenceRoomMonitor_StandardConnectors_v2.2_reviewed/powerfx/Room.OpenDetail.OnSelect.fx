Set(gblSelectedRoom, ThisItem);
Set(
    gblSelectedRoomStatus,
    LookUp(
        colRoomView,
        RoomEmail = gblSelectedRoom.RoomEmail
    )
);
Navigate(scrRoomDetail, ScreenTransition.Fade);
