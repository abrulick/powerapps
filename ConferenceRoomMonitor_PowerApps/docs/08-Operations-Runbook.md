# Operations Runbook

## Daily checks
- Failed or partial runs in CRM_FlowLog
- Unknown/stale room statuses
- Critical/high open issues
- Rooms unexpectedly marked OutOfService

## Common incident: room shows Unknown
1. Confirm the room is active in CRM_Rooms.
2. Confirm RoomEmail is correct.
3. Confirm the monitoring account still has calendar permission.
4. Confirm room calendar still appears for monitoring account.
5. Test `Get calendar view of events (V3)` in the flow.
6. Refresh/re-authenticate the Office 365 Outlook connection if necessary.
7. Inspect Conditional Access / DLP changes.

## Common incident: room always shows Free
1. Create a controlled test booking.
2. Confirm the booking appears in the room mailbox.
3. Confirm flow time-zone conversion.
4. Confirm the flow uses the correct CalendarId.
5. Confirm event status filtering is not excluding Busy events.
6. Confirm SnapshotUtc is current.

## Common incident: duplicate daily metrics
Use MetricKey as the upsert key. Change the flow from unconditional Create item to:
- Get items filtered by MetricKey
- Update if found
- Create if not found

## Common incident: reports miss rows
Check for nondelegable Power Fx formulas. Date filtering against SharePoint should happen before local GroupBy/Sum operations. Keep report date windows small enough for the collected aggregate set, or create monthly rollups for a very large estate.

## Change management
When adding columns:
1. Add to SharePoint.
2. Refresh Power Apps data source.
3. Update flows.
4. Test in non-production.
5. Publish.
6. Record change in release notes.

## Ownership
Document:
- Power App owner
- Power Automate flow owner
- Monitoring account owner
- Exchange administrator contact
- SharePoint site owner
- AV support group
- Facilities support group
