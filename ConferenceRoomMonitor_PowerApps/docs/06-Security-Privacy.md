# Security, Privacy, and Governance

## Principles
- Least privilege
- Store only data required for the business purpose
- Avoid raw meeting content
- Separate operations from analytics
- Make administrative actions auditable
- Restrict issue/feedback data to appropriate support roles

## Meeting data
Default:
- Current subject: not stored
- Organizer: not stored
- Attendees: never stored
- Body: never stored
- Historical metrics: timestamps/counts only

## SharePoint permissions
Recommended SharePoint groups:
- `CRM App Users`: Read Rooms/RoomStatus/Metrics; Contribute Feedback/Issues/CheckIns
- `CRM Support`: Contribute Issues and Feedback; Read operational lists
- `CRM Admins`: Full control on solution lists
- `CRM Flow Account`: required list permissions

Because SharePoint list-level permissions are not column security, do not place sensitive data in columns that broad app users can read.

## Anonymous feedback
"Anonymous" means the app intentionally leaves `SubmittedBy` blank in the feedback record. SharePoint may still retain audit metadata such as Created By depending on how the item is written and your tenant configuration. Do not promise legal anonymity without validating your tenant's audit behavior.

For stronger anonymity, route feedback through a Power Automate flow owned by a service account and store only the fields your privacy team approves.

## App admin authorization
Create a SharePoint group or `CRM_Admins` list and gate admin navigation with explicit membership. Do not rely on hiding a button as the only authorization control; SharePoint permissions must enforce the same access boundary.

## Retention suggestions
Example only; align to company policy:
- RoomStatus: current rows only
- FlowLog: 90 days
- CheckIns: 90–180 days
- Feedback: 12–24 months
- Issues: 24–36 months
- Daily metrics: 24–36 months or longer if approved

## DLP
Confirm that Office 365 Outlook, SharePoint, and any optional Graph/Teams connectors are allowed together in the environment's Power Platform DLP policy.
