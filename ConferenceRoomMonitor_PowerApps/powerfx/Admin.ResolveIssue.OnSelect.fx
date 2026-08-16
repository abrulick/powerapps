If(
    !gblIsAdmin,
    Notify("You are not authorized for this action.", NotificationType.Error, 3000),
    If(
        IsBlank(Trim(txtResolution.Text)),
        Notify("Enter a resolution note.", NotificationType.Warning, 3000),
        IfError(
            Patch(
                CRM_Issues,
                galAdminIssues.Selected,
                {
                    Status: {Value: "Resolved"},
                    ResolvedUtc: gblNowUtc,
                    Resolution: Trim(txtResolution.Text)
                }
            ),
            Notify("Issue could not be resolved.", NotificationType.Error, 4000),
            Refresh(CRM_Issues);
            Notify("Issue resolved.", NotificationType.Success, 2500)
        )
    )
)
