# CRM10DiagnosticCapabilities

Trigger: Manual during implementation.

Do not expose this diagnostic flow to broad app users.

## Test A — Dynamic inventory

- Get room lists (V2)
- Get rooms in room list (V2)
- confirm expected SMTP addresses

## Test B — Batched availability

Create two known test-room states:
- one definitely free
- one definitely busy

Call Find meeting times (V2) with both as ResourceAttendees using an exact short window.

Inspect:
- meetingTimeSuggestions
- attendeeAvailability
- address
- availability

Pass only if the output can be deterministically mapped back to each room.

Repeat with a future conflict to validate the StartingSoon horizon logic.

## Test C — Enhanced shared calendar

If Enhanced is planned:
1. grant an administrator-approved permission level satisfying the connector's view-and-edit requirement to one test room
2. Get calendars (V2)
3. verify owner address
4. Get calendar view of events (V3)

Do not assume Reviewer is sufficient.

## Test D — attendee fields

Create a meeting with:
- required people
- optional person
- room resource

Verify V3 event fields expose required/optional/resource strings as expected.

## Test E — RSVP diagnostic

Optionally inspect raw V3 action output for stable per-attendee status objects.

Do not enable RSVP analytics unless the data is consistently present and supported in your tenant.

## Record results

Document:
- Baseline availability = PASS/FAIL
- Enhanced calendar detail = PASS/FAIL
- People demand = PASS/FAIL
- RSVP enhancement = PASS/FAIL
