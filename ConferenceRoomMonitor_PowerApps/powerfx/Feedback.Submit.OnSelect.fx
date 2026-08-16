If(
    IsBlank(varFeedbackRating) || varFeedbackRating < 1 || varFeedbackRating > 5,
    Notify("Select a rating from 1 to 5.", NotificationType.Warning, 3000),
    IfError(
        Patch(
            CRM_Feedback,
            Defaults(CRM_Feedback),
            {
                Title: gblSelectedRoom.Title & " feedback",
                RoomEmail: Lower(gblSelectedRoom.RoomEmail),
                SubmittedUtc: gblNowUtc,
                Rating: varFeedbackRating,
                Category: {Value: cmbFeedbackCategory.Selected.Value},
                Comment: Trim(txtFeedbackComment.Text),
                Anonymous: togAnonymous.Checked,
                FollowUpRequested: togFollowUp.Checked,
                Status: {Value: "New"},
                SubmittedBy:
                    If(
                        togAnonymous.Checked,
                        Blank(),
                        {
                            '@odata.type': "#Microsoft.Azure.Connectors.SharePoint.SPListExpandedUser",
                            Claims: "i:0#.f|membership|" & gblUserEmail,
                            DisplayName: gblUserName,
                            Email: gblUserEmail
                        }
                    )
            }
        ),
        Notify("Feedback could not be submitted.", NotificationType.Error, 4000),
        Notify("Thank you for the feedback.", NotificationType.Success, 2500);
        Reset(txtFeedbackComment);
        Reset(togAnonymous);
        Reset(togFollowUp);
        Set(varFeedbackRating, Blank());
        Back()
    )
)
