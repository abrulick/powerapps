If(
    !gblIssueBusy,
    If(
        IsBlank(cmbIssueSeverity.Selected.Value) ||
        IsBlank(cmbIssueCategory.Selected.Value) ||
        IsBlank(Trim(txtIssueDescription.Text)),

        Notify(
            "Severity, category, and description are required.",
            NotificationType.Warning,
            3000
        ),

        Set(gblIssueBusy, true);

        IfError(
            Set(
                varIssueResult,
                CRM07SubmitIssue.Run(
                    gblSelectedRoom.RoomEmail,
                    cmbIssueSeverity.Selected.Value,
                    cmbIssueCategory.Selected.Value,
                    Trim(txtIssueDescription.Text),
                    User().Email
                )
            );

            Set(gblIssueBusy, false);

            If(
                Coalesce(varIssueResult.success, false),
                Notify("Issue submitted.", NotificationType.Success, 2500);
                Back(),
                Notify(
                    Coalesce(varIssueResult.message, "Issue could not be submitted."),
                    NotificationType.Error,
                    4000
                )
            ),

            Set(gblIssueBusy, false);
            Notify(
                "Issue could not be submitted. " & FirstError.Message,
                NotificationType.Error,
                5000
            )
        )
    )
)
