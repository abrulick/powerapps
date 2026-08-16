# CRM-02-RefreshRoomStatus

Trigger: Recurrence every 5 minutes.

## Purpose
Build a lightweight current-status cache for every active room.

## Inputs
- Active room rows from `CRM_Rooms`
- Outlook calendar data
- `StartingSoonMinutes`
- `PersistMeetingSubject`
- `PersistOrganizer`

## Standard connector implementation

For each active room:

1. If `OutOfService = Yes`
   - Upsert `CRM_RoomStatus`:
     - Status = OutOfService
     - SnapshotUtc = utcNow()
   - Continue.

2. Resolve the room calendar available to the monitoring account.
   Recommended implementation:
   - During initial setup, add each room calendar to the monitoring account.
   - Use Office 365 Outlook `Get calendars (V2)` and match owner/address/name to the room.
   - Cache the resolved calendar identifier in a new optional text column `CalendarId` on `CRM_Rooms`.

3. Office 365 Outlook — `Get calendar view of events (V3)`
   - Calendar Id = room CalendarId
   - Start = now minus 15 minutes
   - End = now plus 24 hours
   - Order by start ascending
   - Top = 50

4. Filter returned events:
   - ignore canceled events if exposed
   - treat Busy / Tentative / OOF as occupied according to business policy
   - identify one current event: Start <= now < End
   - identify first future event: Start > now

5. Set status:
   - Current event exists -> Busy
   - Else future event starts within `StartingSoonMinutes` -> StartingSoon
   - Else -> Free

6. Privacy fields:
   - If `PersistMeetingSubject` false, store blank CurrentSubject.
   - If `PersistOrganizer` false, store blank CurrentOrganizer.

7. Upsert `CRM_RoomStatus` by RoomEmail.

8. On per-room error:
   - Status = Unknown
   - SourceState = Error
   - ErrorText = concise connector error
   - SnapshotUtc = utcNow()

## Important connector limit

`Get calendar view of events (V3)` has a maximum of 256 events per call. This flow only requests a narrow window, so 50 is normally sufficient. Historical aggregation should page if the selected interval can exceed the connector limit.

## Concurrency

Start with Apply-to-each concurrency = 4. Increase only after testing throttling in your tenant.
