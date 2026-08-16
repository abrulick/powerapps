If(
    gblRoomDetailAvailable && !IsBlank(ThisItem.PlannedPeople),
    "Planned people: " & ThisItem.PlannedPeople,
    ""
)
