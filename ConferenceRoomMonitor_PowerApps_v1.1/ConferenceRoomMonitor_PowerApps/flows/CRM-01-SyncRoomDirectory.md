# CRM-01-SyncRoomDirectory

Trigger: Recurrence daily at 04:30 local time.  
During build, also create a temporary manual-trigger copy if useful.

## Purpose
Synchronize room directory and resolve calendar identifiers for the monitoring account.

## Actions

1. Office 365 Outlook — `Get room lists (V2)`.
2. Office 365 Outlook — `Get calendars (V2)` once; keep the result for CalendarId matching.
3. For each room list:
   - `Get rooms in room list (V2)`.
   - For each room:
     - normalize email to lowercase.
     - find the corresponding calendar from the `Get calendars (V2)` result using owner/address where available.
     - upsert `CRM_Rooms` by RoomEmail.
     - write Title, RoomEmail, RoomListEmail, CalendarId, LastDirectorySyncUtc.
4. Office 365 Outlook — `Get rooms (V2)` as a fallback to catch rooms outside room lists.
5. Do not delete absent rooms automatically. Mark inactive only under an explicit aging/admin rule.
6. Log run state to `CRM_FlowLog`.

## Gate
Do not enable the status flow until every monitored active room has:
- valid RoomEmail
- calendar access for the monitoring account
- a resolved CalendarId

If a shared room calendar does not appear in `Get calendars (V2)`, recheck Outlook sharing/add-calendar state and connector ownership.
