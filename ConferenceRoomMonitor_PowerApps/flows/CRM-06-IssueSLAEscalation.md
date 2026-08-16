# CRM-06-IssueSLAEscalation

Trigger: Recurrence hourly.

## Purpose
Escalate open issues that have missed their SLA.

## Query
Get items from `CRM_Issues` where:
- Status is not Resolved/Closed
- TargetUtc is not blank
- TargetUtc <= utcNow()

Use SharePoint OData filtering where practical and enable pagination.

## For each overdue issue

1. Skip if a notification was sent too recently according to your escalation policy.
2. Increment EscalationLevel.
3. Choose recipients:
   - Level 1: operational support group
   - Level 2+: operational support + IssueManagementEmail
4. Send escalation email.
5. Update LastNotificationUtc and EscalationLevel.
6. Log failures.

The app sets ResolvedUtc when an administrator/support user resolves an issue. Resolved/Closed items are excluded from future escalation runs.
