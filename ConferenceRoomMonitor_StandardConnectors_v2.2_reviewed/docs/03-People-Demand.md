# People-Demand Model

People demand is an **Enhanced Calendar Detail** feature because it requires event attendee fields.

## Metrics

### InviteeCount
Unique, nonblank required + optional attendee address entries.

Resource attendees are excluded.

### PlannedPeople
Unique required + optional attendee entries + organizer, deduplicated.

The organizer address is used only transiently for counting and is not returned to Power Apps or persisted to the reporting mailbox.

## Counting algorithm in Power Automate

For each event:

1. Normalize required attendees to lowercase.
2. Normalize optional attendees to lowercase.
3. Split semicolon-delimited values.
4. Remove blank elements.
5. Combine arrays.
6. Use `union(array,array)` to remove duplicates.
7. `InviteeCount = length(unique invitees)`.
8. If organizer address is nonblank, append it to a temporary array and deduplicate again.
9. `PlannedPeople = length(unique invitees + organizer)`.

Do not count ResourceAttendees.

## Important limitation: groups

If an attendee address is a distribution list or Microsoft 365 group, the standard event field represents that address as one entry. Therefore `PlannedPeople` can understate actual headcount.

Label the metric:
**Planned people (address-based proxy)**

unless you have separately validated group-expansion behavior.

## RSVP responses

Accepted/Tentative/Declined counts remain optional diagnostic data.

Do not derive individual RSVP state from the event's top-level `ResponseType`; that describes the calendar owner's response, not every attendee.

## Historical privacy

Persist only:
- InviteeCount
- PlannedPeople
- meeting start/end/duration
- room identity

Do not persist:
- attendee addresses
- organizer address
- subject
- body
