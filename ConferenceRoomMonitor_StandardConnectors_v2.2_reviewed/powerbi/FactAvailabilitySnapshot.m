let
    Source =
        Table.SelectRows(
            CRM_BaseMail,
            each
                Record.FieldOrDefault(
                    [Payload],
                    "schema",
                    ""
                ) = "crm.availabilitySnapshot.v2.2"
        ),

    WithSnapshot =
        Table.AddColumn(
            Source,
            "SnapshotUtc",
            each DateTimeZone.FromText(Record.Field([Payload], "snapshotUtc")),
            type datetimezone
        ),

    WithCorrelation =
        Table.AddColumn(
            WithSnapshot,
            "CorrelationId",
            each Text.From(Record.Field([Payload], "correlationId")),
            type text
        ),

    WithRooms =
        Table.AddColumn(
            WithCorrelation,
            "Rooms",
            each Record.FieldOrDefault([Payload], "rooms", {}),
            type list
        ),

    ExpandedList = Table.ExpandListColumn(WithRooms, "Rooms"),

    Expanded =
        Table.ExpandRecordColumn(
            ExpandedList,
            "Rooms",
            {"roomListName", "roomName", "roomEmail", "status", "known", "occupied"},
            {"RoomListName", "RoomName", "RoomEmail", "Status", "Known", "Occupied"}
        ),

    Typed =
        Table.TransformColumnTypes(
            Expanded,
            {
                {"RoomListName", type text},
                {"RoomName", type text},
                {"RoomEmail", type text},
                {"Status", type text},
                {"Known", type logical},
                {"Occupied", type logical}
            }
        ),

    Dedup =
        Table.Distinct(
            Typed,
            {"CorrelationId", "RoomEmail"}
        )
in
    Dedup
