With(
    {
        _list: Coalesce(cmbRoomList.Selected.Value, "All"),
        _status: Coalesce(cmbStatus.Selected.Value, "All"),
        _search: Lower(Trim(txtRoomSearch.Text))
    },
    SortByColumns(
        Filter(
            colRoomView,
            (_list = "All" || RoomListName = _list) &&
            (_status = "All" || LiveStatus = _status) &&
            (
                IsBlank(_search) ||
                StartsWith(Lower(RoomName), _search) ||
                StartsWith(RoomEmail, _search)
            )
        ),
        "RoomName",
        SortOrder.Ascending
    )
)
