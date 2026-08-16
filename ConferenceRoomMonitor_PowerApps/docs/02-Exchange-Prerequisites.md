# Exchange / Outlook Prerequisites

## Room mailbox prerequisites

Every monitored room should exist as a Microsoft 365 room mailbox with a unique SMTP address.

Recommended Exchange administration:
1. Ensure rooms are grouped into room lists where possible.
2. Ensure room names, locations, and capacities are maintained consistently.
3. Use a dedicated monitoring/service account for Power Automate connections.
4. Grant that monitoring account read-only calendar access to each room.

Example Exchange Online PowerShell:

```powershell
# Example only; run with an Exchange Online administrator session.
$Monitor = "roommonitor@contoso.com"
$Room = "conf-101@contoso.com"

Add-MailboxFolderPermission `
  -Identity "$Room`:\Calendar" `
  -User $Monitor `
  -AccessRights Reviewer
```

If an entry already exists, use:

```powershell
Set-MailboxFolderPermission `
  -Identity "$Room`:\Calendar" `
  -User $Monitor `
  -AccessRights Reviewer
```

Verify:

```powershell
Get-MailboxFolderPermission `
  -Identity "$Room`:\Calendar" `
  -User $Monitor
```

## Calendar visibility

The monitoring account must be able to retrieve the room calendar through Office 365 Outlook. After permission is granted:
1. Sign into Outlook on the web as the monitoring account.
2. Add the room calendar from the directory.
3. Confirm the room appears under shared calendars and that free/busy or details are visible according to policy.
4. In Power Automate, refresh the Office 365 Outlook connection and verify the calendar can be selected or discovered.

## Meeting subject and organizer

For privacy, this kit does not require subjects or organizers.

If the business requires those fields, Exchange resource-calendar processing settings may affect whether room events retain the original meeting subject. Review your organization's privacy policy before changing any `Set-CalendarProcessing` settings.

## Service account recommendations

- Dedicated licensed Microsoft 365 account
- No interactive business use
- MFA/Conditional Access configured according to your security policy
- Least privilege only
- SharePoint site access restricted to the app/operations team
- Office 365 Outlook and SharePoint connections owned by the service account or solution owner
- Document owner transfer / break-glass procedure

## Standard-mode limitation

The standard Office 365 Outlook connector reads calendars that the connection identity can access. This is why the monitoring account requires calendar access.

For a large room estate or when administrators do not want shared calendars attached to a monitoring account, see the optional Microsoft Graph pattern.
