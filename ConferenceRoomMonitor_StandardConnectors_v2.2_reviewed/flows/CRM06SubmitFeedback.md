# CRM06SubmitFeedback

Trigger: Power Apps (V2)

Inputs:
- roomEmail
- rating
- category
- comment
- anonymous
- submittedByEmail

## Validate

1. Dynamically discover room inventory.
2. Reject roomEmail not in inventory.
3. Rating must be 1–5.
4. Category must be from an approved list.
5. Truncate/validate comment length.

## Record

Create:
- schema = crm.feedback.v2.2
- appVersion = 2.2
- recordId = guid()
- submittedUtc = utcNow()
- canonical room name/list from server-side discovery, not client display text

If anonymous, omit submittedBy.

## Persist

Use Send an email (V2) from monitoring account TO the shared mailbox.

Subject:
`[CRM-FEEDBACK] <recordId>`

Body:
Base64-wrapped JSON protocol from `docs/04-Shared-Mailbox-Protocol.md`.

Respond success/recordId.

## Caller identity note

`submittedByEmail` comes from Power Apps `User().Email` and is useful contact/display metadata, but the flow must not use that value for authorization. Treat it as caller-supplied data unless your tenant adds a separate trusted caller-identity mechanism.
