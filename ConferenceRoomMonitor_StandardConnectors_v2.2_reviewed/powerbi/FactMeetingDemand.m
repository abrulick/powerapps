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

    WithMeetings =
        Table.AddColumn(
            WithGenerated,
            "Meetings",
            each Record.FieldOrDefault([Payload], "meetings", {}),
            type list
        ),

    ExpandedList = Table.ExpandListColumn(WithMeetings, "Meetings"),

    Expanded =
        Table.ExpandRecordColumn(
            ExpandedList,
            "Meetings",
            {
                "roomEmail",
                "startUtc",
                "endUtc",
                "durationMinutes",
                "inviteeCount",
                "plannedPeople"
            },
            {
                "RoomEmail",
                "StartUtcText",
                "EndUtcText",
                "DurationMinutes",
                "InviteeCount",
                "PlannedPeople"
            }
        ),

    Converted =
        Table.TransformColumns(
            Expanded,
            {
                {"StartUtcText", each DateTimeZone.FromText(_), type datetimezone},
                {"EndUtcText", each DateTimeZone.FromText(_), type datetimezone}
            }
        ),

    Renamed =
        Table.RenameColumns(
            Converted,
            {
                {"StartUtcText", "StartUtc"},
                {"EndUtcText", "EndUtc"}
            }
        ),

    Typed =
        Table.TransformColumnTypes(
            Renamed,
            {
                {"RoomEmail", type text},
                {"DurationMinutes", Int64.Type},
                {"InviteeCount", Int64.Type},
                {"PlannedPeople", Int64.Type}
            }
        ),

    Grouped =
        Table.Group(
            Typed,
            {"MetricDate", "RoomEmail", "StartUtc", "EndUtc"},
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
            {"MetricDate", "RoomEmail", "StartUtc", "EndUtc"}
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
