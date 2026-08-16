# Microsoft 365 Conference Room Monitor — Standard Connector Edition

Version: **2.2 Reviewed**

## Architecture

- Power Apps Canvas
- Power Automate
- Office 365 Outlook standard connector
- shared Exchange mailbox
- Power BI
- optional Microsoft Teams connector

Not used:
- direct Microsoft Graph API
- custom connectors
- SharePoint
- Dataverse
- SQL
- check-in

## Major v2.2 change

Live status is no longer calculated independently for every Power Apps user.

A scheduled flow centrally refreshes a sanitized status snapshot every five minutes and stores the current snapshot in the shared mailbox. App users retrieve that snapshot through a lightweight Power Automate flow.

This greatly reduces:
- connector calls
- app start latency
- synchronous-flow timeout risk
- dependence on the number of simultaneous app users

See `CODE_REVIEW.md`.

## Two capability profiles

### Baseline — recommended first deployment

Uses:
- Exchange room lists for dynamic inventory
- Outlook `Find meeting times (V2)` for batched availability
- mailbox status cache
- Power Apps runtime collections
- shared mailbox feedback/issues
- sampled availability analytics in Power BI

Does **not** require the app to retrieve room event details.

### Enhanced Calendar Detail

Adds:
- exact current/next booking windows
- room-day timeline
- exact daily booked minutes
- meeting counts
- invited/planned people analytics

This uses:
- `Get calendars (V2)`
- `Get calendar view of events (V3)`

Microsoft's current connector documentation says shared calendars are available to calendar actions only when the connection user has **view and edit** permission. Validate the permission model with Exchange/security before enabling Enhanced mode.

## Exact flow names

Create the flows with these exact names so the supplied Power Fx formulas resolve without renaming:

- `CRM01DiscoverRoomInventory`
- `CRM02RefreshRoomStatusCache`
- `CRM03GetRoomStatusCache`
- `CRM04FindAvailableRooms`
- `CRM05GetRoomDayDetail`
- `CRM06SubmitFeedback`
- `CRM07SubmitIssue`
- `CRM08EmitAvailabilitySnapshot`
- `CRM09EmitDailyMetrics`
- `CRM10DiagnosticCapabilities`

## Start here

1. `CODE_REVIEW.md`
2. `docs/00-Architecture.md`
3. `docs/02-Capability-Modes-and-Calendar-Access.md`
4. `docs/10-One-Pass-Implementation.md`
