With(
    {
        _status: Coalesce(ThisItem.LiveStatus, "Unknown"),
        _snap: ThisItem.SnapshotUtcValue
    },
    If(
        !IsBlank(_snap) &&
        DateDiff(_snap, gblNowUtc, TimeUnit.Minutes) > gblStatusStaleMinutes,
        "STALE",
        Upper(_status)
    )
)
