# Comprehensive Code Review — v2.1 → v2.2

Review date: 2026-08-16  
Reviewed scope:
- architecture
- Office 365 Outlook connector assumptions
- Power Automate call patterns
- Power Fx
- mailbox persistence
- Power BI ingestion/model
- privacy/security
- deployment/operations

## Executive assessment

v2.1 had a sound high-level database-free concept but was not production-ready. The review found five release-blocking issues and several high-impact design weaknesses.

v2.2 fixes the code-level defects and changes the live-status architecture so that room polling is centralized instead of repeated by every Power Apps user.

## Critical findings

### C1 — Shared calendar permission assumption was wrong
**v2.1:** recommended `Reviewer` read-only folder access.

Microsoft's current Office 365 Outlook connector documentation says shared calendars appear in calendar triggers/actions only when the connection user has **view and edit** permissions.

**Impact:** `Get calendars (V2)` / event-detail workflows may not see Reviewer-only room calendars.

**v2.2:** separates capabilities:
- Baseline availability mode uses `Find meeting times (V2)` and does not depend on resolving shared Calendar IDs. Validate in your tenant.
- Enhanced event-detail/people-demand mode requires a permission level that satisfies the Outlook connector's view-and-edit requirement. Coordinate this with Exchange/security administrators.

### C2 — Client-provided room inventory crossed a trust boundary
**v2.1:** Power Apps sent `RoomsJson` to service-account flows.

A modified client could inject arbitrary SMTP addresses and ask a privileged flow to query calendars that were not part of the approved room inventory.

**v2.2:** privileged flows independently discover/validate rooms from Exchange room lists. Client input is treated as untrusted.

### C3 — Per-user, per-room polling did not scale
**v2.1:** each app user could invoke one calendar action per room every five minutes.

This risks:
- Power Apps/flow synchronous 120-second response timeout
- Outlook connector throttling
- multiplied load for each simultaneous app user

**v2.2:** a scheduled `CRM02RefreshRoomStatusCache` centrally refreshes status. Power Apps uses `CRM03GetRoomStatusCache`, which only returns the latest sanitized mailbox snapshot.

### C4 — Cross-screen `Select()` in App.OnStart
Power Fx does not allow `Select()` across screens.

**v2.2:** `App.OnStart` loads inventory and sets `gblNeedsStatusRefresh`. `scrDashboard.OnVisible` invokes the dashboard refresh button on the same screen.

### C5 — Time-zone configuration was unused
v2.1 set `gblTimeZoneName`, but future search and day-detail formulas converted using the current user's `TimeZoneOffset()`.

**Impact:** remote users could query the wrong local interval.

**v2.2:** Power Apps sends local wall-clock values plus the configured Windows time-zone name. Power Automate converts with `convertToUtc`.

## High findings

### H1 — Flow display names and Power Fx callable names disagreed
v2.1 guides used names such as `CRM-02-GetLiveRoomStatus` while formulas called `CRM02GetLiveRoomStatus.Run()`.

**v2.2:** all flow guides and Power Fx use the exact same alphanumeric callable names.

### H2 — Flow calls lacked error handling
v2.1 could leave busy indicators set forever or expose raw connector errors.

**v2.2:** app behavior formulas use `IfError`, input validation, busy-state cleanup, and user-safe notifications. Add `App.OnError`.

### H3 — Shared-mailbox Send As was unnecessarily privileged
v2.1 used "Send an email from a shared mailbox".

**v2.2:** the monitoring account sends normal messages **to** the shared mailbox using `Send an email (V2)`. This avoids requiring Send As solely for persistence.

### H4 — Calendar IDs are connection-user specific
Shared-calendar IDs can differ by user; using a different run-only/co-owner connection can cause 404 errors.

**v2.2:** any event-detail flow must pin the Outlook connection to the governed monitoring account and never switch to each app user's Outlook connection.

### H5 — People-demand counting was simplistic
v2.1 used a simple semicolon count.

Problems:
- blank/trailing entries
- duplicates
- organizer excluded
- distribution-list addresses can represent many people

**v2.2:** calculates:
- `InviteeCount` = unique required + optional human-address entries
- `PlannedPeople` = unique invitees + organizer, deduplicated
- never persists identities

The report explicitly labels this as a planning proxy and documents distribution-list undercount risk.

### H6 — Power BI starter query was incomplete
v2.1 only filtered mailbox subjects; it did not decode payloads, create fact tables, or de-duplicate retries.

**v2.2:** adds:
- `CRM_BaseMail.m`
- `FactAvailabilitySnapshot.m`
- `FactRoomDaily.m`
- `FactMeetingDemand.m`
- `FactFeedback.m`
- `FactIssue.m`
- revised DAX
- schema/version/correlation IDs
- latest-record de-duplication guidance

### H7 — Status timer was screen-scoped
Power Apps timers run in the screen context. Detail screens could become stale.

**v2.2:** dashboard status is refreshed on `scrDashboard.OnVisible` when stale. The timer remains a dashboard-only optimization, not the sole refresh mechanism.

## Medium findings / improvements

- Exact calendar matching now prefers `Owner.Address == RoomEmail`; display-name matching is only a unique fallback.
- Calendar errors are never converted to `Free`.
- Status payloads include `snapshotUtc` and app checks freshness.
- Daily metrics define occupied `ShowAs` policy explicitly.
- Historical payloads use versioned schemas and correlation IDs.
- Mailbox payloads are Base64-wrapped JSON to avoid HTML/comment escaping errors.
- Daily and feedback/issue records are idempotent/de-duplicable because Outlook connector retries can produce duplicates.
- Power BI gains an availability-snapshot fact for useful reporting even when enhanced room-calendar access is unavailable.
- Capacity utilization remains disabled unless a trustworthy capacity source is approved.
- RSVP Accepted/Tentative/Declined remains diagnostic only; it is not promised by the documented V3 event output.

## Remaining architectural constraints

These are not code defects:

1. **No database means no structured transactional issue state.**
   The mailbox is an append-only archive, not a relational issue tracker.

2. **Detailed people demand requires event detail access.**
   Baseline availability can work without room event detail, but required/optional attendees come from room events.

3. **Room capacity is not supplied by Outlook room-list discovery.**

4. **Physical occupancy is unavailable for non-instrumented rooms.**

5. **Shared mailbox is durable storage.**
   The design is "database-free", not "persistence-free".

## Recommended deployment profile

Start with **Baseline**:
- dynamic room inventory
- centralized free/busy status cache
- Find Room
- feedback/issues
- sampled utilization in Power BI

Then enable **Enhanced Calendar Detail** only if Exchange/security approves the Outlook connector's required shared-calendar access:
- exact current/next times
- room-day timeline
- exact booked minutes
- meeting count
- invitee/planned-people analytics
