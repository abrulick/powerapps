# CRM-04-FeedbackNotification

Trigger: SharePoint — When an item is created in `CRM_Feedback`.

## Rules

1. If Rating <= 2 OR FollowUpRequested = Yes:
   - Determine room support group from `CRM_Rooms.SupportGroupEmail`.
   - Fall back to `CRM_Settings.FacilitiesEmail`.
   - Send email with:
     - Room
     - Rating
     - Category
     - Comment
     - Submitted time
     - Link to the Power App admin screen or SharePoint item
2. If Rating >= 4:
   - No operational notification required.
3. Update feedback Status from New to Reviewed only if your support workflow explicitly wants auto-triage. Default: leave New.
4. Log failures to `CRM_FlowLog`.

Do not send anonymous submitter identity in notifications.
