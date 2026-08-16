# Test and Deployment Checklist

## Capability test — mandatory
- [ ] CRM10DiagnosticCapabilities runs under monitoring connection.
- [ ] Dynamic room lists return expected rooms.
- [ ] Find meeting times (V2) returns attendeeAvailability for known test rooms.
- [ ] Known Free and Busy rooms map correctly.
- [ ] StartingSoon horizon test works.
- [ ] If Enhanced is planned, approved shared-calendar permission makes room visible in Get calendars (V2).
- [ ] Enhanced flow remains pinned to monitoring-account connection.

## Trust boundary
- [ ] Modify a test client payload with an unauthorized SMTP address.
- [ ] Privileged flow rejects it / never queries it.
- [ ] Room detail validates requested RoomEmail against live room inventory.

## Status cache
- [ ] Scheduled flow creates [CRM-STATUS].
- [ ] App flow retrieves newest valid snapshot.
- [ ] Duplicate status messages do not confuse selection.
- [ ] Stale snapshot is labeled stale/unknown.
- [ ] Status-cache cleanup retains configured short window.

## Scale
- [ ] CRM02 completes comfortably before its next recurrence.
- [ ] App status retrieval returns well below 120 seconds.
- [ ] Outlook connection remains below connector throttling under representative load.
- [ ] Test at production-like room count.

## Power Apps
- [ ] App.OnStart contains no cross-screen Select.
- [ ] Dashboard.OnVisible refreshes stale state.
- [ ] Flow errors clear busy indicators.
- [ ] Inventory failure shows user-safe message.
- [ ] Find Room rejects past/invalid intervals.
- [ ] Room detail handles Enhanced-unavailable state.
- [ ] Feedback validates rating/category.
- [ ] Issue validates severity/category/description.
- [ ] Double-submit buttons are disabled while busy.

## Time zone / DST
- [ ] Test user in room's time zone.
- [ ] Test user/device in a different time zone.
- [ ] Same local requested room time is queried in both cases.
- [ ] Test a DST boundary day if relevant.

## People demand — Enhanced
- [ ] Required + optional duplicates are deduplicated.
- [ ] blank attendee strings count as zero.
- [ ] organizer counted once.
- [ ] resource attendee excluded.
- [ ] distribution-list limitation documented.

## Power BI
- [ ] CRM_BaseMail decodes Base64 payload.
- [ ] FactAvailabilitySnapshot loads.
- [ ] FactRoomDaily loads only if Enhanced enabled.
- [ ] duplicate DailyMetrics run keeps latest.
- [ ] feedback/issue recordId deduplication works.
- [ ] sampled utilization and exact utilization are clearly labeled.
