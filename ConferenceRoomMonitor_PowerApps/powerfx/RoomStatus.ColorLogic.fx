Switch(
    Coalesce(ThisItem.LiveStatus, "Unknown"),
    "Free", ColorValue("#107C10"),
    "Busy", ColorValue("#D13438"),
    "StartingSoon", ColorValue("#F7630C"),
    "OutOfService", ColorValue("#605E5C"),
    ColorValue("#8A8886")
)
