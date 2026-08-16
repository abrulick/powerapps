// Discovered rooms
CountRows(colRooms)

// Free
CountIf(colRoomView, LiveStatus = "Free")

// Busy
CountIf(colRoomView, LiveStatus = "Busy")

// Starting soon
CountIf(colRoomView, LiveStatus = "StartingSoon")

// Unknown
CountIf(colRoomView, LiveStatus = "Unknown")

// Status freshness
If(gblStatusStale, "STALE", "CURRENT")
