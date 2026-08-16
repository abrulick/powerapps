If(
    !gblFeedbackBusy,
    If(
        IsBlank(varFeedbackRating) ||
        varFeedbackRating < 1 ||
        varFeedbackRating > 5 ||
        IsBlank(cmbFeedbackCategory.Selected.Value),

        Notify(
            "Select a rating and feedback category.",
            NotificationType.Warning,
            3000
        ),

        Set(gblFeedbackBusy, true);

        IfError(
            Set(
                varFeedbackResult,
                CRM06SubmitFeedback.Run(
                    gblSelectedRoom.RoomEmail,
                    varFeedbackRating,
                    cmbFeedbackCategory.Selected.Value,
                    Trim(txtFeedbackComment.Text),
                    togAnonymous.Checked,
                    User().Email
                )
            );

            Set(gblFeedbackBusy, false);

            If(
                Coalesce(varFeedbackResult.success, false),
                Notify("Feedback submitted.", NotificationType.Success, 2500);
                Back(),
                Notify(
                    Coalesce(varFeedbackResult.message, "Feedback could not be submitted."),
                    NotificationType.Error,
                    4000
                )
            ),

            Set(gblFeedbackBusy, false);
            Notify(
                "Feedback could not be submitted. " & FirstError.Message,
                NotificationType.Error,
                5000
            )
        )
    )
)
