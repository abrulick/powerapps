# Tenant Prerequisites

## Baseline

Required:
- Power Apps Canvas
- Power Automate
- Office 365 Outlook connector allowed by DLP
- Exchange room lists
- governed monitoring/service account
- shared Exchange mailbox
- Power BI Desktop
- Power BI Service publish rights if sharing the report
- monitoring account access to the shared mailbox

Not required:
- direct Microsoft Graph API
- app registration
- HTTP with Entra ID
- custom connector
- SharePoint
- Dataverse
- SQL
- Teams Rooms Pro

## Enhanced Calendar Detail

Additional requirement:
- room calendars must be discoverable through `Get calendars (V2)` for the monitoring connection.
- Microsoft's current Outlook connector documentation says shared calendars appear in calendar actions only when the connection user has **view and edit** permissions.

Do not assume `Reviewer` is sufficient.

Have Exchange/security administrators determine the approved folder-sharing permission that satisfies the connector requirement.

## Connection ownership

All Outlook actions in privileged flows must use the monitoring account connection.

Do not configure a Power Apps run-only user to supply their own Outlook connection for room-detail actions, because shared calendar IDs are connection-user specific.

## Tenant values

- `DefaultTimeZoneName` = `REPLACE_ME` (Windows time-zone name, e.g. `Eastern Standard Time`)
- `SharedMailbox` = `REPLACE_ME-room-operations@contoso.com`
- `MonitoringSender` = `REPLACE_ME-roommonitor@contoso.com`
- `StartingSoonMinutes` = 15
- `StatusFreshnessMinutes` = 12
- `StatusRefreshMinutes` = 5
- `AnalyticsSampleMinutes` = 15
- `BusinessDayStart` = 08:00
- `BusinessDayEnd` = 18:00

## Multi-time-zone estates

v2.2 assumes one default room time zone unless you explicitly configure a room-list-to-time-zone mapping.

Do not use the Power Apps user's local device time zone as the room time zone.
