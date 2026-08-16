# CRM-05-IssueIntakeNotification

Trigger: SharePoint — When an item is created in `CRM_Issues`.

## Purpose
Set initial SLA target and notify the correct support group.

## Actions

1. Read settings.
2. Resolve SLA hours from Severity:
   - Low -> IssueSlaLowHours
   - Medium -> IssueSlaMediumHours
   - High -> IssueSlaHighHours
   - Critical -> IssueSlaCriticalHours
3. Calculate TargetUtc.
4. Resolve destination:
   - AV / Display / Camera / Microphone / Speaker / Connectivity -> AVSupportEmail
   - all other categories -> FacilitiesEmail
   - room `SupportGroupEmail` overrides if populated
5. Update the issue with TargetUtc.
6. Send notification with room, category, severity, description, created time, and item/app link.
7. For Critical:
   - set EscalationLevel = 1
   - notify AVSupportEmail + FacilitiesEmail.
8. Log failures.

This is an event-driven flow and has one trigger.
