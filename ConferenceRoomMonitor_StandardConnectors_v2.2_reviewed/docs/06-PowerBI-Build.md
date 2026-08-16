# Power BI Build

## Connector

Use Microsoft Exchange Online Power Query connector in Import mode.

Source mailbox:
`REPLACE_ME-room-operations@contoso.com`

The included M queries expect the CRM messages in a configured folder path, default `\Inbox\`.

## Queries

Create/import in this order:

1. `pMailbox`
2. `pFolderPath`
3. `CRM_BaseMail`
4. `FactAvailabilitySnapshot`
5. `FactRoomDaily`
6. `FactMeetingDemand`
7. `FactFeedback`
8. `FactIssue`

## Baseline reporting

Available without Enhanced Calendar Detail:

- Sampled Utilization %
- Free/Busy sample trends
- room availability by day/time
- feedback
- issues
- monitoring health

Sampled utilization is an approximation based on retained 15-minute availability snapshots.

## Enhanced reporting

Adds:
- exact booked utilization
- meeting count
- average planned people per meeting
- peak planned people
- meeting-size distribution
- people demand by hour/day

## Important distinction

Do not put sampled and exact utilization on the same visual without labeling them.

Recommended measure names:
- `Sampled Utilization %`
- `Exact Booked Utilization %`

## Mailbox source integrity

Mailbox is the durable source. Do not delete retained analytics records unless Power BI history is intentionally being discarded.

`[CRM-STATUS]` cache messages are transient and can be cleaned up independently.
