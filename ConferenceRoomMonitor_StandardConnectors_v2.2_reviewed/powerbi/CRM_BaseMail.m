let
    Source = Exchange.Contents(pMailbox),
    Mail = Source{[Name="Mail"]}[Data],

    CRMOnly =
        Table.SelectRows(
            Mail,
            each
                [Folder Path] = pFolderPath and
                Text.StartsWith([Subject], "[CRM-")
        ),

    BodyText =
        Table.AddColumn(
            CRMOnly,
            "CRM_BodyText",
            each
                let
                    b = [Body],
                    bodyText =
                        if b = null then
                            ""
                        else if Value.Is(b, type text) then
                            b
                        else if Value.Is(b, type record) then
                            let
                                names = Record.FieldNames(b),
                                preferred =
                                    List.Select(
                                        {"TextBody", "Text", "Content", "Body"},
                                        each List.Contains(names, _)
                                    ),
                                candidate =
                                    if List.Count(preferred) > 0
                                    then Record.Field(b, preferred{0})
                                    else ""
                            in
                                try Text.From(candidate) otherwise ""
                        else
                            try Text.From(b) otherwise ""
                in
                    bodyText,
            type text
        ),

    Payload64 =
        Table.AddColumn(
            BodyText,
            "CRM_Payload64",
            each
                try
                    Text.BetweenDelimiters(
                        [CRM_BodyText],
                        "CRMJSON64:",
                        ":ENDCRMJSON64"
                    )
                otherwise
                    null,
            type text
        ),

    Payload =
        Table.AddColumn(
            Payload64,
            "Payload",
            each
                if [CRM_Payload64] = null then
                    null
                else
                    try
                        Json.Document(
                            Binary.FromText(
                                Text.Trim([CRM_Payload64]),
                                BinaryEncoding.Base64
                            )
                        )
                    otherwise
                        null,
            type any
        ),

    Valid =
        Table.SelectRows(
            Payload,
            each [Payload] <> null
        ),

    Result =
        Table.SelectColumns(
            Valid,
            {"Subject", "Payload"}
        )
in
    Result
