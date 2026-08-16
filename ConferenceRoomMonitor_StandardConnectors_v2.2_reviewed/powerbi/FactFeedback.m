let
    Source =
        Table.SelectRows(
            CRM_BaseMail,
            each
                Record.FieldOrDefault([Payload], "schema", "") =
                "crm.feedback.v2.2"
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
                "rating",
                "category",
                "anonymous"
            },
            {
                "RecordId",
                "SubmittedUtcText",
                "RoomEmail",
                "RoomName",
                "RoomListName",
                "Rating",
                "Category",
                "Anonymous"
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

    Typed =
        Table.TransformColumnTypes(
            Renamed,
            {
                {"RecordId", type text},
                {"RoomEmail", type text},
                {"RoomName", type text},
                {"RoomListName", type text},
                {"Rating", Int64.Type},
                {"Category", type text},
                {"Anonymous", type logical}
            }
        ),

    Dedup = Table.Distinct(Typed, {"RecordId"})
in
    Dedup
