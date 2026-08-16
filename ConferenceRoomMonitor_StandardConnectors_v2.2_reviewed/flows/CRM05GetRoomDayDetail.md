# CRM05GetRoomDayDetail

Trigger: Power Apps (V2)

Capability: **Enhanced Calendar Detail**

Inputs:
- roomEmail
- localDate (`yyyy-MM-dd` or literal `TODAY`)
- timeZoneName

Outputs:
- detailAvailable
- eventsJson
- errorText

## Authorization / validation

1. Dynamically discover Exchange room inventory.
2. Verify lowercase roomEmail exists in discovered rooms.
3. Reject otherwise.

## Calendar resolution

1. Get calendars (V2) using the monitoring-account connection.
2. Prefer exact:
   `lower(Calendar.Owner.Address) == lower(roomEmail)`.
3. If owner address is unavailable, allow only a unique, administratively verified fallback.
4. If unresolved, return `detailAvailable=false`.

## Local day boundaries

If `localDate == TODAY`, calculate the room-local date in the flow:

```text
ResolvedLocalDate =
  formatDateTime(
    convertTimeZone(utcNow(), 'UTC', timeZoneName),
    'yyyy-MM-dd'
  )
```

Otherwise validate the supplied `yyyy-MM-dd`.

Convert each local boundary independently:

```text
StartUtc = convertToUtc(ResolvedLocalDate + "T00:00:00", timeZoneName)
EndUtc   = convertToUtc(nextLocalDate + "T00:00:00", timeZoneName)
```

This is DST-safe and does not depend on the Power Apps user's device time zone.

## Events

Get calendar view of events (V3).

Occupied policy:
- busy -> occupied
- tentative -> occupied by default
- oof -> occupied
- free -> not occupied
- workingElsewhere -> not occupied
- unknown -> data-quality exception; do not silently call it free

For each occupied event:
- startUtc
- endUtc
- inviteeCount
- plannedPeople

Do not return attendee identities, subject, organizer, or body.
