# Shared Mailbox Protocol

Mailbox:
`REPLACE_ME-room-operations@contoso.com`

## Why the mailbox is used

It provides:
- a shared status cache
- append-only feedback and issue archive
- database-free analytics source for Power BI

## Sending pattern

Use **Office 365 Outlook — Send an email (V2)** from the monitoring account **to** the shared mailbox.

Do not require "Send from a shared mailbox (V2)" merely to persist a record.

## Message prefixes

- `[CRM-STATUS]` — transient current status cache
- `[CRM-AVAILABILITY]` — retained sampled-utilization snapshot
- `[CRM-FEEDBACK]`
- `[CRM-ISSUE]`
- `[CRM-DAILY-METRICS]` — Enhanced
- `[CRM-FLOW-ERROR]`

## Payload envelope

Every record includes:
- schema
- appVersion
- correlationId
- generated/submitted timestamp

Encode the JSON string as Base64 and place this exact marker in the HTML body:

```text
CRMJSON64:<base64 JSON>:ENDCRMJSON64
```

This avoids HTML escaping corrupting quotes, ampersands, and user comments.

Conceptual Power Automate body:

```text
<pre>CRMJSON64:@{base64(string(outputs('Compose_Payload')))}:ENDCRMJSON64</pre>
```

## Current status schema

```json
{
  "schema": "crm.status.v2.2",
  "appVersion": "2.2",
  "correlationId": "guid",
  "snapshotUtc": "2026-08-16T17:30:00Z",
  "rooms": [
    {
      "roomListName": "HQ",
      "roomName": "Conference 101",
      "roomEmail": "conf101@contoso.com",
      "status": "Free",
      "availability": "free",
      "error": ""
    }
  ]
}
```

`[CRM-STATUS]` is a cache. Retain only a short window, for example 2–24 hours.

## Availability analytics schema

```json
{
  "schema": "crm.availabilitySnapshot.v2.2",
  "appVersion": "2.2",
  "correlationId": "guid",
  "snapshotUtc": "2026-08-16T17:30:00Z",
  "rooms": [
    {
      "roomListName": "HQ",
      "roomName": "Conference 101",
      "roomEmail": "conf101@contoso.com",
      "status": "Busy",
      "known": true,
      "occupied": true
    }
  ]
}
```

Retain these for Power BI.

## Feedback schema

```json
{
  "schema": "crm.feedback.v2.2",
  "appVersion": "2.2",
  "recordId": "guid",
  "submittedUtc": "2026-08-16T17:15:00Z",
  "roomEmail": "conf101@contoso.com",
  "roomName": "Conference 101",
  "roomListName": "HQ",
  "rating": 2,
  "category": "AV",
  "comment": "Camera was not detected.",
  "anonymous": false,
  "submittedBy": "user@contoso.com"
}
```

Omit `submittedBy` from the JSON when Anonymous = true.

## Issue schema

Same envelope plus:
- severity
- category
- description

## Enhanced daily metrics schema

```json
{
  "schema": "crm.dailyMetrics.v2.2",
  "appVersion": "2.2",
  "correlationId": "guid",
  "metricDate": "2026-08-15",
  "generatedUtc": "2026-08-16T05:30:00Z",
  "timeZoneName": "Eastern Standard Time",
  "rooms": [
    {
      "roomEmail": "conf101@contoso.com",
      "roomName": "Conference 101",
      "roomListName": "HQ",
      "availableMinutes": 600,
      "bookedMinutes": 360,
      "meetingCount": 6,
      "totalInvitees": 26,
      "totalPlannedPeople": 32,
      "peakPlannedPeople": 9,
      "overlapDetected": false
    }
  ],
  "meetings": [
    {
      "roomEmail": "conf101@contoso.com",
      "startUtc": "2026-08-15T13:00:00Z",
      "endUtc": "2026-08-15T14:00:00Z",
      "durationMinutes": 60,
      "inviteeCount": 4,
      "plannedPeople": 5
    }
  ]
}
```

## Duplicate safety

Outlook actions can retry after timeouts, including send operations.

Therefore Power BI must de-duplicate:
- feedback/issues by `recordId`
- daily metrics by `metricDate + roomEmail`, keeping latest `generatedUtc`
- snapshot data by `correlationId + roomEmail`
