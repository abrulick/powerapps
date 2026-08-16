# Operational Runbook

## Every day

Check:
- newest [CRM-STATUS] snapshot timestamp
- CRM02 scheduled-flow failures
- Unknown-room count
- shared mailbox delivery failures
- CRM08 / CRM09 reporting flow health

## Status cache stale

1. Confirm CRM02 ran.
2. Confirm room discovery returned rooms.
3. Inspect Find meeting times response.
4. Check Outlook connection authentication.
5. Check connector throttling.
6. Keep app status Unknown/Stale until a healthy snapshot arrives.

## New room appears but Enhanced detail is unavailable

This is expected when:
- room exists in Exchange room list
- but its calendar is not discoverable to the monitoring connection

Baseline status can still work if Find meeting times supports the room.

## Connection owner change

Re-test Enhanced mode completely.

Shared-calendar IDs are user-specific, so changing the Outlook connection owner can invalidate saved calendar identifiers/mappings.

## Mailbox growth

Transient [CRM-STATUS]:
- retain only short history

Retained:
- [CRM-AVAILABILITY]
- [CRM-FEEDBACK]
- [CRM-ISSUE]
- [CRM-DAILY-METRICS]

Set retention based on business/reporting policy.

## Connector load

Office 365 Outlook has per-connection throttling.

If load grows:
1. increase app timer interval
2. reduce status-cache refresh frequency
3. reduce batch size only if action latency/errors indicate it helps
4. avoid per-user event polling
5. keep Enhanced detail on demand
