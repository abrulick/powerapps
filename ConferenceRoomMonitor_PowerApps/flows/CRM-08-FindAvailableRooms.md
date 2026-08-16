# CRM-08-FindAvailableRooms

Trigger: Power Apps (V2).

## Inputs

- `StartUtc` — text, ISO UTC
- `EndUtc` — text, ISO UTC
- `MinCapacity` — number
- `Building` — text (`All` allowed)
- `RequireTeamsRoom` — boolean
- `RequireWhiteboard` — boolean

## Output

Use `Respond to a PowerApp or flow` with:
- `AvailableRoomEmailsCsv` — text, semicolon-delimited lowercase emails
- `AvailableCount` — number
- `ErrorCount` — number

## Purpose
Return actual candidate rooms for a future requested slot without asking the canvas app to directly iterate calendars.

## Actions

1. Get active, not-out-of-service `CRM_Rooms`.
2. Filter candidates:
   - Capacity >= MinCapacity
   - Building matches unless All
   - HasTeamsRoom if required
   - HasWhiteboard if required
   - CalendarId is not blank
3. Initialize:
   - array/string variable for available room emails
   - ErrorCount = 0
4. Apply to each candidate, recommended concurrency 4:
   - `Get calendar view of events (V3)`
   - CalendarId = candidate CalendarId
   - Start = StartUtc
   - End = EndUtc
   - Top = 25
   - Determine whether any non-canceled/non-free event overlaps the requested slot.
   - If none overlap: append room email.
   - On per-room connector failure: increment ErrorCount; do not report the room as available.
5. Join available emails with `;`.
6. Respond to Power Apps.

## Safety rule
A failed availability check must produce an error/omission, never a false "available" result.
