# One-Pass Implementation

## Pass 0 — Decide capability profile

Run `CRM10DiagnosticCapabilities` first.

Choose:

**Baseline**
- always implement first
- availability + Find Room + feedback/issues + sampled utilization

**Enhanced**
- only after Exchange/security approves and validates the shared-calendar permission model
- adds exact timeline and people-demand analytics

## 1 — Create/configure shared mailbox

Grant the monitoring account:
- ability to deliver records to it
- ability for status-reader flow / Power BI identity to read it as required

No Send As permission is required solely for persistence.

## 2 — Build CRM01DiscoverRoomInventory

Gate:
- dynamic inventory is correct
- new Exchange room appears without app republish

## 3 — Build CRM10DiagnosticCapabilities

Gate:
- batched Find meeting times maps test resources correctly

If this gate fails, do not fake availability. Escalate connector/tenant-policy validation.

## 4 — Build CRM02RefreshRoomStatusCache

Schedule every 5 minutes initially.

Gate:
- one status snapshot contains all approved rooms
- failures map to Unknown
- snapshot timestamp/correlationId populated

## 5 — Build CRM03GetRoomStatusCache

Gate:
- returns newest valid status payload
- reports stale cache
- no room-calendar polling is performed here

## 6 — Build CRM04FindAvailableRooms

Gate:
- requested interval converts using configured room time zone
- conflicting rooms excluded
- unknown room availability excluded

## 7 — Build feedback/issues

- CRM06SubmitFeedback
- CRM07SubmitIssue

Both validate the room against live inventory before writing.

## 8 — Build CRM08EmitAvailabilitySnapshot

Schedule every 15 minutes.
Retain these messages for baseline Power BI utilization.

## 9 — Optional Enhanced setup

Only now configure approved room-calendar sharing for the monitoring account.

Test:
- Get calendars (V2)
- exact owner-address matching
- Get calendar view of events (V3)

## 10 — Build CRM05GetRoomDayDetail

Enhanced only.

## 11 — Build CRM09EmitDailyMetrics

Enhanced only.

Reconcile booked minutes and planned-people counts manually for several rooms.

## 12 — Build Power Apps

Apply Power Fx in this package.

## 13 — Build Power BI

Use the included M queries and DAX.

## 14 — Security/performance test

Complete `09-Test-Deployment.md`.

## 15 — Launch

Enable scheduled flows, publish app/report, and monitor:
- cache freshness
- diagnostic failures
- Outlook connector throttling
- Enhanced calendar-access exceptions
