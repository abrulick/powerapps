# Optional Microsoft Graph Availability Adapter

Use this only if your organization approves the required connector/licensing and Graph permissions.

## Why use it

Microsoft Graph `getSchedule` is purpose-built for free/busy lookup of users and resources. It can query up to 20 entities in one call and returns schedule items plus an availability view.

This can replace the per-room calendar polling portion of `CRM-02-RefreshRoomStatus`.

## Suggested endpoint

`POST /v1.0/me/calendar/getSchedule`

Example request body:

```json
{
  "schedules": [
    "room101@contoso.com",
    "room102@contoso.com"
  ],
  "startTime": {
    "dateTime": "2026-08-15T08:00:00",
    "timeZone": "Eastern Standard Time"
  },
  "endTime": {
    "dateTime": "2026-08-16T08:00:00",
    "timeZone": "Eastern Standard Time"
  },
  "availabilityViewInterval": 15
}
```

## Batching
Chunk active rooms into groups of 20.

## Permissions
Use the least privileged permission approved for your chosen delegated/application model. Coordinate with Entra/Exchange administrators.

## Privacy
Free/busy status is sufficient for most dashboards. Do not request or store subject/location/organizer detail unless approved.

## Keep the rest of the solution unchanged
The adapter should still upsert the same `CRM_RoomStatus` schema, so the Power App and reporting layers remain independent of the calendar ingestion mechanism.
