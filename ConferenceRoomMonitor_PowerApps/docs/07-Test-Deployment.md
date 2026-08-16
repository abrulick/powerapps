# Test and Deployment Checklist

## Data foundation
- [ ] All eleven SharePoint lists created.
- [ ] Indexes created.
- [ ] Settings records populated.
- [ ] CRM_Admins contains at least one administrator.
- [ ] Three or more rooms synchronized.
- [ ] CalendarId resolved for each monitored test room.

## Exchange / Outlook
- [ ] Monitoring account can open each room calendar.
- [ ] Get room lists (V2) works.
- [ ] Get rooms in room list (V2) works.
- [ ] Get rooms (V2) fallback works.
- [ ] Get calendars (V2) exposes the monitored room calendars.
- [ ] Get calendar view of events (V3) returns test bookings.
- [ ] Recurring instances appear in calendar view.

## Flow 01
- [ ] Upserts rooms.
- [ ] Resolves CalendarId.
- [ ] Does not duplicate room rows.

## Flow 02
- [ ] Free status.
- [ ] Busy status.
- [ ] StartingSoon status.
- [ ] OutOfService precedence.
- [ ] Connector failure -> Unknown, never Free.
- [ ] One status row per room.

## Flow 03
- [ ] Creates yesterday room-day metrics.
- [ ] Rerun updates rather than duplicates.
- [ ] Booked minutes reconcile with calendar.
- [ ] EstateDaily row equals sum of room-day totals.
- [ ] RoomRolling row exists for each room.
- [ ] 7/30/90 utilization values recalculate correctly.

## Flow 04
- [ ] Low feedback sends support notification.
- [ ] Follow-up request sends support notification.
- [ ] Anonymous feedback email omits submitter identity.

## Flow 05
- [ ] New issue receives TargetUtc.
- [ ] Category routes to correct support destination.
- [ ] Critical issue notifies both AV and Facilities.

## Flow 06
- [ ] Overdue open issue escalates.
- [ ] EscalationLevel increments.
- [ ] Resolved/Closed items do not escalate.

## Flow 07
- [ ] Weekly totals reconcile with aggregate lists.
- [ ] Highest/lowest room ranking is correct.

## Flow 08
- [ ] Future free room is returned.
- [ ] Conflicting room is excluded.
- [ ] OutOfService room is excluded.
- [ ] Capacity/amenity/building filters work.
- [ ] Calendar error does not return false availability.

## Power App
- [ ] App.OnStart loads without errors.
- [ ] Admin button hidden for non-admin.
- [ ] Building/floor/capacity/search filters work.
- [ ] Available-only filter works.
- [ ] Room detail shows current/next windows.
- [ ] Check-in prevents duplicate user/booking submission.
- [ ] Feedback submits.
- [ ] Issue submits.
- [ ] Find-room results match Outlook calendars.
- [ ] 7/30/90 reports load.
- [ ] Charts use aggregate caches, not raw room-day history.
- [ ] Narrow layout remains usable.
- [ ] No critical delegation warnings remain.

## Security/privacy
- [ ] Meeting subject persistence disabled unless approved.
- [ ] Organizer persistence disabled unless approved.
- [ ] Standard-user SharePoint permissions tested.
- [ ] Support permissions tested.
- [ ] Admin permissions tested.
- [ ] Anonymous-feedback language approved.
- [ ] DLP policy approved.
- [ ] Retention policy approved.

## Go-live
- [ ] Publish app.
- [ ] Share app with approved groups.
- [ ] Enable scheduled flows.
- [ ] Disable build/test duplicates.
- [ ] Monitor CRM_FlowLog during stabilization.
