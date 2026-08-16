# Capability Modes and Calendar Access

## Mode A — Baseline Availability

Use first.

Features:
- dynamic room discovery
- Free / Busy / StartingSoon / Unknown
- future Find Room
- feedback/issues
- sampled utilization

Primary Outlook action:
- `Find meeting times (V2)`

Advantages:
- no shared Calendar Id resolution in the live dashboard path
- batched resource availability
- much lower connector-call volume

Run `CRM10DiagnosticCapabilities` before production and verify that:
- room SMTP addresses work as ResourceAttendees
- `attendeeAvailability` is returned per room
- known busy/free test rooms map correctly

## Mode B — Enhanced Calendar Detail

Features added:
- exact Busy-until
- exact next booking
- today's timeline
- meeting count
- exact booked minutes
- invitee/planned-people metrics

Actions:
- `Get calendars (V2)`
- `Get calendar view of events (V3)`

### Permission warning

Microsoft currently documents that shared calendars appear in calendar triggers/actions only if the user has **view and edit** permissions.

Therefore:
- do not provision Reviewer and assume success
- test approved permissions in a nonproduction room
- if security rejects edit-level sharing, remain in Baseline mode

### Calendar matching

Always match in this order:

1. `lower(Calendar.Owner.Address) == lower(RoomEmail)`
2. unique verified address/name mapping only if owner address is unavailable
3. otherwise fail closed

Never silently select the first calendar with a similar display name.

### Connection pinning

Shared calendar IDs are user-specific.

Every enhanced flow must use the monitoring account's Outlook connection consistently. A co-owner or run-only user must not substitute their own Outlook connection.

## Why both modes exist

The database-free design should remain useful even if Enhanced permissions are not approved.

Baseline answers:
- Is the room available?
- Which rooms are free for a requested interval?
- What portion of sampled business time is occupied?

Enhanced answers:
- Exactly how long was it booked?
- How many meetings occurred?
- How many people were invited/planned?
