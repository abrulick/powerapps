# CRM03GetRoomStatusCache

Trigger: Power Apps (V2)

Inputs:
- freshnessMinutes (Number)

Outputs:
- statusJson (Text)
- snapshotUtc (Text)
- stale (Boolean)
- errorText (Text)

## Steps

1. Office 365 Outlook — Get emails (V3).
2. Original Mailbox Address = shared mailbox.
3. Use Search Query for `[CRM-STATUS]`; do not rely on Subject Filter for a large folder.
4. Retrieve a small set of candidates.
5. Extract CRMJSON64 payloads.
6. Decode Base64 and parse JSON.
7. Select the payload with the greatest `snapshotUtc`.
8. Validate `schema == crm.status.v2.2`.
9. Compare snapshotUtc to utcNow.
10. Return the rooms array JSON and stale flag.

This flow performs no room-calendar polling.
