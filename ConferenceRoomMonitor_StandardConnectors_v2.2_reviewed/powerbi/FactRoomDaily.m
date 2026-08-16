let
    Source =
        Table.SelectRows(
            CRM_BaseMail,
            each
                Record.FieldOrDefault([Payload], "schema", "") =
                "crm.dailyMetrics.v2.2"
        ),

    WithMetricDate =
        Table.AddColumn(
            Source,
            "MetricDate",
            each Date.FromText(Record.Field([Payload], "metricDate")),
            type date
        ),

    WithGenerated =
        Table.AddColumn(
            WithMetricDate,
            "GeneratedUtc",
            each DateTimeZone.FromText(Record.Field([Payload], "generatedUtc")),
            type datetimezone
        ),

    WithRooms =
        Table.AddColumn(
            WithGenerated,
            "Rooms",
            each Record.FieldOrDefault([Payload], "rooms", {}),
            type list
        ),

    ExpandedList = Table.ExpandListColumn(WithRooms, "Rooms"),

    Expanded =
        Table.ExpandRecordColumn(
            ExpandedList,
            "Rooms",
            {
                "roomEmail",
                "roomName",
                "roomListName",
                "availableMinutes",
                "bookedMinutes",
                "meetingCount",
                "totalInvitees",
                "totalPlannedPeople",
                "peakPlannedPeople",
                "overlapDetected"
            },
            {
                "RoomEmail",
                "RoomName",
                "RoomListName",
                "AvailableMinutes",
                "BookedMinutes",
                "MeetingCount",
                "TotalInvitees",
                "TotalPlannedPeople",
                "PeakPlannedPeople",
                "OverlapDetected"
            }
        ),

    Typed =
        Table.TransformColumnTypes(
            Expanded,
            {
                {"RoomEmail", type text},
                {"RoomName", type text},
                {"RoomListName", type text},
                {"AvailableMinutes", Int64.Type},
                {"BookedMinutes", Int64.Type},
                {"MeetingCount", Int64.Type},
                {"TotalInvitees", Int64.Type},
                {"TotalPlannedPeople", Int64.Type},
                {"PeakPlannedPeople", Int64.Type},
                {"OverlapDetected", type logical}
            }
        ),

    Grouped =
        Table.Group(
            Typed,
            {"MetricDate", "RoomEmail"},
            {
                {
                    "Latest",
                    each Table.First(Table.Sort(_, {{"GeneratedUtc", Order.Descending}})),
                    type record
                }
            }
        ),

    ColumnsToExpand =
        List.RemoveItems(
            Table.ColumnNames(Typed),
            {"MetricDate", "RoomEmail"}
        ),

    LatestOnly =
        Table.ExpandRecordColumn(
            Grouped,
            "Latest",
            ColumnsToExpand,
            ColumnsToExpand
        )
in
    LatestOnly
