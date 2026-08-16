# CRM08EmitAvailabilitySnapshot

Trigger: Recurrence every 15 minutes.

## Purpose

Provide database-free baseline utilization history without detailed shared-calendar event access.

## Algorithm

Use the same validated batched availability method as CRM02, but only the current sample.

For each room emit:
- roomEmail
- canonical room name/list
- status
- known (true/false)
- occupied (true when availability is a configured occupied state)

Persist `crm.availabilitySnapshot.v2.2` to shared mailbox with subject:

`[CRM-AVAILABILITY] <snapshotUtc>`

Retain these messages for Power BI.

## Metric semantics

This yields **sampled utilization**, not exact booked minutes.

At a 15-minute sample:
- a room occupied at the sample interval contributes one occupied sample
- Unknown is excluded from the denominator
