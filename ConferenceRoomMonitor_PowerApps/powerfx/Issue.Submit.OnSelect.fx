If(
    IsBlank(cmbIssueCategory.Selected.Value) ||
    IsBlank(cmbIssueSeverity.Selected.Value) ||
    IsBlank(Trim(txtIssueDescription.Text)),
    Notify("Category, severity, and description are required.", NotificationType.Warning, 3500),
    IfError(
        Patch(
            CRM_Issues,
            Defaults(CRM_Issues),
            {
                Title: gblSelectedRoom.Title & " - " & cmbIssueCategory.Selected.Value,
                RoomEmail: Lower(gblSelectedRoom.RoomEmail),
                CreatedUtc: gblNowUtc,
                Category: {Value: cmbIssueCategory.Selected.Value},
                Severity: {Value: cmbIssueSeverity.Selected.Value},
                Description: Trim(txtIssueDescription.Text),
                Status: {Value: "New"},
                EscalationLevel: 0,
                ReportedBy: {
                    '@odata.type': "#Microsoft.Azure.Connectors.SharePoint.SPListExpandedUser",
                    Claims: "i:0#.f|membership|" & gblUserEmail,
                    DisplayName: gblUserName,
                    Email: gblUserEmail
                }
            }
        ),
        Notify("Issue could not be submitted.", NotificationType.Error, 4000),
        Notify("Issue reported to support.", NotificationType.Success, 2500);
        Reset(txtIssueDescription);
        Back()
    )
)
