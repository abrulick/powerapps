// Rooms monitored
CountRows(colRooms)

// Free now
CountIf(colRoomStatus, Status.Value = "Free")

// Busy now
CountIf(colRoomStatus, Status.Value = "Busy")

// Starting soon
CountIf(colRoomStatus, Status.Value = "StartingSoon")

// Out of service
CountIf(colRoomStatus, Status.Value = "OutOfService")

// Stale / unknown
CountIf(
    colRoomStatus,
    Status.Value = "Unknown" ||
    DateDiff(SnapshotUtc, gblNowUtc, TimeUnit.Minutes) > gblStatusStaleMinutes
)
