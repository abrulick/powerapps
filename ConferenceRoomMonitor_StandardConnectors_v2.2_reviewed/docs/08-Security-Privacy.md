# Security and Privacy

## Service-flow trust boundary

Any flow using the monitoring account must validate requested room identity against live Exchange room-list discovery.

Never trust a Power Apps collection or caller-provided SMTP list as authorization.

## Run-only connections

Privileged Outlook actions must use the monitoring account's fixed connection.

Do not allow app users to substitute their own Outlook connection.

## Shared calendar access

Enhanced mode may require view-and-edit room-calendar permissions due to connector behavior.

Treat this as a deliberate security exception:
- test one room
- document scope
- limit service account permissions to monitored rooms
- do not grant mailbox-wide privileges unnecessarily

## Data minimization

Power Apps receives:
- room identity
- availability
- sanitized times/counts

It does not receive:
- attendee addresses
- meeting body
- subject
- organizer identity

Historical analytics stores counts only.

## Shared mailbox

Limit mailbox read access to:
- solution owner
- Power BI/service identity
- approved operations staff

The mailbox is a system of record for this design; apply retention/backup controls accordingly.

## Anonymous feedback

The JSON omits submittedBy, but Microsoft 365/Power Platform audit logs can still identify execution actors. Do not represent this as legal anonymity.
