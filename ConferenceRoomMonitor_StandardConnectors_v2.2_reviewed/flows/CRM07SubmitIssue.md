# CRM07SubmitIssue

Trigger: Power Apps (V2)

Inputs:
- roomEmail
- severity
- category
- description
- submittedByEmail

## Validate

- rediscover and authorize roomEmail
- severity allow-list
- category allow-list
- description nonblank and length constrained

## Persist

Create `crm.issue.v2.2` with recordId/correlationId and canonical server-side room metadata.

Use Send an email (V2) from monitoring account TO shared mailbox.

Subject:
`[CRM-ISSUE] <severity> | <recordId>`

## Optional Teams notification

For High/Critical:
- post sanitized room/category/severity/description
- do not post meeting details or attendee data

Respond success/recordId.

## Caller identity note

`submittedByEmail` comes from Power Apps `User().Email` and is useful contact/display metadata, but the flow must not use that value for authorization. Treat it as caller-supplied data unless your tenant adds a separate trusted caller-identity mechanism.
