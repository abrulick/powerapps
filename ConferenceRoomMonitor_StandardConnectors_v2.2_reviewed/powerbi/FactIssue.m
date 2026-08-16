let
    Source =
        Table.SelectRows(
            CRM_BaseMail,
            each
                Record.FieldOrDefault([Payload], "schema", "") =
                "crm.issue.v2.2"
        ),

    Records =
        Table.AddColumn(Source, "Record", each [Payload], type record),

    Expanded =
        Table.ExpandRecordColumn(
            Records,
            "Record",
            {
                "recordId",
                "submittedUtc",
                "roomEmail",
                "roomName",
                "roomListName",
                "severity",
                "category"
            },
            {
                "RecordId",
                "SubmittedUtcText",
                "RoomEmail",
                "RoomName",
                "RoomListName",
                "Severity",
                "Category"
            }
        ),

    Converted =
        Table.TransformColumns(
            Expanded,
            {
                {"SubmittedUtcText", each DateTimeZone.FromText(_), type datetimezone}
            }
        ),

    Renamed = Table.RenameColumns(Converted, {{"SubmittedUtcText", "SubmittedUtc"}}),
    Dedup = Table.Distinct(Renamed, {"RecordId"})
in
    Dedup
