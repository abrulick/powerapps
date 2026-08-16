With(
    {
        _building: Coalesce(cmbBuilding.Selected.Value, "All"),
        _floor: Coalesce(cmbFloor.Selected.Value, "All"),
        _search: Lower(Trim(txtRoomSearch.Text)),
        _minCap: Coalesce(cmbCapacity.Selected.MinCapacity, 0)
    },
    SortByColumns(
        Filter(
            AddColumns(
                colRooms As R,
                LiveStatus,
                    Coalesce(
                        LookUp(
                            colRoomStatus As S,
                            Lower(S.RoomEmail) = Lower(R.RoomEmail),
                            S.Status.Value
                        ),
                        "Unknown"
                    ),
                SnapshotUtcValue,
                    LookUp(
                        colRoomStatus As S,
                        Lower(S.RoomEmail) = Lower(R.RoomEmail),
                        S.SnapshotUtc
                    ),
                CurrentEndUtcValue,
                    LookUp(
                        colRoomStatus As S,
                        Lower(S.RoomEmail) = Lower(R.RoomEmail),
                        S.CurrentEndUtc
                    ),
                NextStartUtcValue,
                    LookUp(
                        colRoomStatus As S,
                        Lower(S.RoomEmail) = Lower(R.RoomEmail),
                        S.NextStartUtc
                    )
            ),
            (_building = "All" || Building.Value = _building) &&
            (_floor = "All" || Floor = _floor) &&
            (Capacity >= _minCap) &&
            (
                IsBlank(_search) ||
                StartsWith(Lower(Title), _search) ||
                StartsWith(Lower(RoomEmail), _search)
            ) &&
            (!togAvailableOnly.Checked || LiveStatus = "Free")
        ),
        "SortOrder",
        SortOrder.Ascending,
        "Title",
        SortOrder.Ascending
    )
)
