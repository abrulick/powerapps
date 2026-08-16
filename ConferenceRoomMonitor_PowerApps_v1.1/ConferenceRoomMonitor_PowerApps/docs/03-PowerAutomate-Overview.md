# Power Automate Overview

Create the flows in `flows/` in numeric order.

## Required connections

Standard:
- Office 365 Outlook
- SharePoint
- Microsoft 365 Users (optional for resolving people)
- Microsoft Teams (optional if you prefer Teams notifications)

## Connection owner

Use the same solution/monitoring account for the scheduled flows where governance permits.

## Error-handling standard

Every scheduled flow should use three scopes:
- `TRY`
- `CATCH`
- `FINALLY`

Configure `CATCH` to run after failure, timeout, or skip of `TRY`.
Log every run to `CRM_FlowLog`.

## Idempotency

Directory, status, and metric flows must upsert by stable keys:
- Rooms: lowercase RoomEmail
- RoomStatus: lowercase RoomEmail
- Daily metrics: lowercase RoomEmail + local MetricDate

Never use room display name as the unique key.
