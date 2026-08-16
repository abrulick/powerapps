ClearCollect(colFloorOptions, {Value: "All"});
Collect(
    colFloorOptions,
    Sort(
        Distinct(
            Filter(
                colRooms,
                (Self.Selected.Value = "All" || Building.Value = Self.Selected.Value) &&
                !IsBlank(Floor)
            ),
            Floor
        ),
        Value,
        SortOrder.Ascending
    )
);
Reset(cmbFloor);
