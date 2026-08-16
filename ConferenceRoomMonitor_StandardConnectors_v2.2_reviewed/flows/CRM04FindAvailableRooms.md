# CRM04FindAvailableRooms

Trigger: Power Apps (V2)

Inputs:
- localStart (Text, `yyyy-MM-ddTHH:mm:ss`)
- durationMinutes (Number)
- timeZoneName (Text)
- roomListFilter (Text, `All` allowed)

Outputs:
- availableRoomsJson
- unknownCount
- errorText

## Security

Do not accept a room SMTP list from Power Apps.

Rediscover approved room inventory inside this flow.

## Time conversion

```text
StartUtc = convertToUtc(localStart, timeZoneName)
EndUtc   = addMinutes(StartUtc, durationMinutes)
```

## Validation

- durationMinutes must be positive and within your approved maximum.
- reject malformed localStart/timeZoneName.
- reject intervals whose computed EndUtc is not after StartUtc.
- optionally reject a requested interval that is already fully in the past.

## Availability

1. Filter discovered rooms by room list.
2. Partition into conservative batches.
3. Find meeting times (V2):
   - resources = batch room addresses
   - Start = StartUtc
   - End = EndUtc
   - MeetingDuration = durationMinutes
   - MaxCandidates = 1
   - MinimumAttendeePercentage = 0
   - IsOrganizerOptional = true
   - ActivityDomain = Unrestricted
4. Read attendeeAvailability for the exact interval.
5. Return only rooms explicitly reported free.
6. Unknown/missing resources are excluded, never treated as available.
