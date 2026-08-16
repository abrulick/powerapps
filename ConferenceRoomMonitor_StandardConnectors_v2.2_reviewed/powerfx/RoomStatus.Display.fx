If(
    gblStatusStale,
    "STALE",
    Switch(
        ThisItem.LiveStatus,
        "Free", "FREE",
        "Busy", "BUSY",
        "StartingSoon", "STARTING SOON",
        "UNKNOWN"
    )
)
