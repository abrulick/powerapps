# CRM02RefreshRoomStatusCache

Trigger: Recurrence every 5 minutes.

## Purpose

Centralize room polling so app-user count does not multiply calendar calls.

## Standard availability engine

1. Dynamically discover approved room inventory.
2. Partition room SMTP addresses into conservative batches (start with 20; this is a tuning choice, not a documented connector maximum).
3. For each batch run Find meeting times (V2) for the **current 1-minute interval**:
   - ResourceAttendees = semicolon list of batch room addresses
   - MeetingDuration = 1
   - Start = utcNow()
   - End = addMinutes(utcNow(), 1)
   - MaxCandidates = 1
   - MinimumAttendeePercentage = 0
   - IsOrganizerOptional = true
   - ActivityDomain = Unrestricted
4. Read `attendeeAvailability` by resource address.
5. Repeat for the **StartingSoon horizon**:
   - Start = same base time
   - End = addMinutes(base, StartingSoonMinutes)
   - MeetingDuration = StartingSoonMinutes
6. Derive:
   - current availability non-free -> Busy
   - current free AND horizon free -> Free
   - current free AND horizon non-free -> StartingSoon
   - missing/unknown -> Unknown
7. Create `crm.status.v2.2`.
8. Send the Base64-wrapped payload with subject `[CRM-STATUS] <snapshotUtc>` from monitoring account to shared mailbox.
9. Cleanup old [CRM-STATUS] messages according to short retention.

## Fail closed

Any batch/action ambiguity returns Unknown for affected rooms.

## Why diagnostic validation is mandatory

Find meeting times is a scheduling-suggestion API. This design deliberately constrains the suggestion window to the exact requested duration so attendeeAvailability acts as a batched availability surface.

Validate this behavior against known free/busy rooms in your tenant before production.
