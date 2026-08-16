# Architecture

## Baseline data flow

```text
Exchange room lists
       │
       ▼
CRM02RefreshRoomStatusCache   (scheduled, centralized)
       │
       ├── Find meeting times (V2), batched
       │
       ▼
Shared mailbox: [CRM-STATUS]
       │
       ▼
CRM03GetRoomStatusCache
       │
       ▼
Power Apps runtime collections
```

Power Apps users do not independently poll every room.

## Persistence

The shared mailbox stores:
- transient `[CRM-STATUS]` cache messages
- retained `[CRM-AVAILABILITY]` analytical snapshots
- `[CRM-FEEDBACK]`
- `[CRM-ISSUE]`
- optional `[CRM-DAILY-METRICS]` enhanced analytics

No structured application database exists.

## Baseline availability

`Find meeting times (V2)` accepts resource attendees and returns per-attendee availability in meeting-time suggestions.

The status-cache flow uses small room batches and two exact windows:

1. **Now window** — detect currently Free vs occupied.
2. **Starting Soon horizon** — if currently Free but not free for the complete horizon, classify `StartingSoon`.

This is an availability model, not event-detail retrieval.

The capability must be verified in `CRM10DiagnosticCapabilities` because tenant policies can affect scheduling behavior.

## Enhanced event detail

When approved, `CRM05GetRoomDayDetail` and `CRM09EmitDailyMetrics` use shared room calendars.

The monitoring connection must:
- own the Outlook connector connection used by the flow
- be able to resolve the room in `Get calendars (V2)`
- satisfy the connector's shared-calendar permission requirements

## Trust boundary

Power Apps is not trusted to supply the authoritative room inventory.

Flows that use the monitoring account:
- rediscover room lists server-side, or
- validate a requested RoomEmail against current room-list discovery

This prevents a modified client from using the service connection to inspect arbitrary calendars.

## Analytics

### Baseline
`CRM08EmitAvailabilitySnapshot` captures a compact status sample every 15 minutes.

Power BI calculates **Sampled Utilization %**:
occupied known samples / all known samples.

### Enhanced
`CRM09EmitDailyMetrics` calculates exact:
- booked minutes
- meeting count
- invitee count
- planned people
- meeting-size distributions

## Data freshness

Every snapshot includes:
- `schema`
- `snapshotUtc` or `generatedUtc`
- `correlationId`

Power Apps shows `STALE`/`UNKNOWN` if the status cache exceeds the configured freshness threshold.
