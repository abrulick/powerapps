# SharePoint Schema

Create all lists in one SharePoint site. Create columns using the exact internal names below first; you can change display labels later.

## 1. CRM_Rooms

| Column | Type | Required | Notes |
|---|---|---:|---|
| Title | Single line text | Yes | Room display name |
| RoomEmail | Single line text | Yes | Unique room SMTP address |
| RoomListEmail | Single line text | No | Room list SMTP address |
| CalendarId | Single line text | No | Calendar ID resolved for monitoring account |
| Building | Choice | No | Site/building |
| Floor | Single line text | No | Floor label |
| Capacity | Number | No | Integer |
| IsActive | Yes/No | Yes | Default Yes |
| OutOfService | Yes/No | Yes | Default No |
| OutOfServiceReason | Multiple lines | No | |
| AVProfile | Choice | No | Basic, TeamsRoom, Advanced, Specialty |
| HasTeamsRoom | Yes/No | No | |
| HasDisplay | Yes/No | No | |
| HasCamera | Yes/No | No | |
| HasWhiteboard | Yes/No | No | |
| HasHDMI | Yes/No | No | |
| HasUSB-C | Yes/No | No | |
| HasWirelessShare | Yes/No | No | |
| Accessibility | Choice | No | Standard, Accessible |
| SupportGroupEmail | Single line text | No | Room-specific escalation destination |
| SortOrder | Number | No | |
| LastDirectorySyncUtc | Date/Time | No | |

Indexes: `RoomEmail`, `Building`, `IsActive`.

## 2. CRM_RoomStatus

Exactly one current row per room.

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| RoomEmail | Single line text | Yes |
| SnapshotUtc | Date/Time | Yes |
| Status | Choice | Yes |
| CurrentStartUtc | Date/Time | No |
| CurrentEndUtc | Date/Time | No |
| NextStartUtc | Date/Time | No |
| NextEndUtc | Date/Time | No |
| CurrentSubject | Single line text | No |
| CurrentOrganizer | Single line text | No |
| DataFreshnessMinutes | Number | No |
| SourceState | Choice | No |
| ErrorText | Multiple lines | No |

Status: `Free`, `Busy`, `StartingSoon`, `OutOfService`, `Unknown`.  
SourceState: `Healthy`, `Partial`, `Error`.

Indexes: `RoomEmail`, `Status`, `SnapshotUtc`.

## 3. CRM_RoomDailyMetrics

One row per room per local calendar day.

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| MetricKey | Single line text | Yes |
| RoomEmail | Single line text | Yes |
| MetricDate | Date only | Yes |
| Building | Single line text | No |
| Floor | Single line text | No |
| Capacity | Number | No |
| AvailableMinutes | Number | Yes |
| BookedMinutes | Number | Yes |
| UtilizationPct | Number | Yes |
| MeetingCount | Number | Yes |
| AvgMeetingMinutes | Number | No |
| CheckedInMeetings | Number | No |
| InferredNoShows | Number | No |
| PeakHour | Number | No |
| FeedbackCount | Number | No |
| RatingSum | Number | No |
| AvgRating | Number | No |
| Rating1Count | Number | No |
| Rating2Count | Number | No |
| Rating3Count | Number | No |
| Rating4Count | Number | No |
| Rating5Count | Number | No |
| IssueCount | Number | No |
| HighCriticalIssueCount | Number | No |
| CalculationUtc | Date/Time | Yes |

`MetricKey`: `lower(roomEmail)|yyyy-MM-dd`.

Indexes: `MetricKey`, `MetricDate`, `RoomEmail`, `Building`.

## 4. CRM_RoomRollingMetrics

One row per room. This keeps room-comparison reporting below client row limits.

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| RoomEmail | Single line text | Yes |
| AsOfDate | Date only | Yes |
| Building | Single line text | No |
| Floor | Single line text | No |
| Utilization7d | Number | No |
| Utilization30d | Number | No |
| Utilization90d | Number | No |
| BookedHours7d | Number | No |
| BookedHours30d | Number | No |
| BookedHours90d | Number | No |
| MeetingCount7d | Number | No |
| MeetingCount30d | Number | No |
| MeetingCount90d | Number | No |
| AvgRating30d | Number | No |
| FeedbackCount30d | Number | No |
| IssueCount30d | Number | No |
| InferredNoShows30d | Number | No |
| UpdatedUtc | Date/Time | Yes |

Indexes: `RoomEmail`, `Building`.

## 5. CRM_EstateDailyMetrics

One row per day for all monitored rooms. This feeds long-range estate charts without scanning all room-day rows in the app.

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| MetricDate | Date only | Yes |
| AvailableMinutes | Number | Yes |
| BookedMinutes | Number | Yes |
| UtilizationPct | Number | Yes |
| MeetingCount | Number | Yes |
| FeedbackCount | Number | No |
| RatingSum | Number | No |
| AvgRating | Number | No |
| Rating1Count | Number | No |
| Rating2Count | Number | No |
| Rating3Count | Number | No |
| Rating4Count | Number | No |
| Rating5Count | Number | No |
| IssueCount | Number | No |
| HighCriticalIssueCount | Number | No |
| InferredNoShows | Number | No |
| CalculationUtc | Date/Time | Yes |

Index: `MetricDate`.

## 6. CRM_CheckIns

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| CheckInKey | Single line text | Yes |
| RoomEmail | Single line text | Yes |
| BookingStartUtc | Date/Time | Yes |
| BookingEndUtc | Date/Time | No |
| CheckInUtc | Date/Time | Yes |
| CheckedInBy | Person | No |
| CheckInMethod | Choice | Yes |
| EventReference | Single line text | No |

`CheckInKey`: `lower(roomEmail)|bookingStartUtc|lower(userEmail)`.

Choices: `PowerApp`, `QR`, `RoomDisplay`, `Admin`.

Indexes: `CheckInKey`, `RoomEmail`, `BookingStartUtc`, `CheckInUtc`.

## 7. CRM_Feedback

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| RoomEmail | Single line text | Yes |
| SubmittedUtc | Date/Time | Yes |
| SubmittedBy | Person | No |
| Rating | Number | Yes |
| Category | Choice | No |
| Comment | Multiple lines | No |
| Anonymous | Yes/No | Yes |
| FollowUpRequested | Yes/No | Yes |
| Status | Choice | Yes |
| AdminNotes | Multiple lines | No |

Category: `Overall`, `AV`, `Cleanliness`, `Comfort`, `Capacity`, `Environment`, `Other`.  
Status: `New`, `Reviewed`, `Closed`.

Indexes: `RoomEmail`, `SubmittedUtc`, `Status`.

## 8. CRM_Issues

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| RoomEmail | Single line text | Yes |
| CreatedUtc | Date/Time | Yes |
| ReportedBy | Person | No |
| Category | Choice | Yes |
| Severity | Choice | Yes |
| Description | Multiple lines | Yes |
| Status | Choice | Yes |
| Owner | Person | No |
| OwnerEmail | Single line text | No |
| TargetUtc | Date/Time | No |
| ResolvedUtc | Date/Time | No |
| Resolution | Multiple lines | No |
| EscalationLevel | Number | No |
| LastNotificationUtc | Date/Time | No |

Category: `AV`, `Display`, `Camera`, `Microphone`, `Speaker`, `Connectivity`, `Power`, `Furniture`, `Cleanliness`, `HVAC`, `Lighting`, `Other`.

Severity: `Low`, `Medium`, `High`, `Critical`.

Status: `New`, `Assigned`, `In Progress`, `Waiting`, `Resolved`, `Closed`.

Indexes: `RoomEmail`, `Status`, `Severity`, `CreatedUtc`, `TargetUtc`.

## 9. CRM_Settings

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| SettingValue | Single line text | No |
| SettingNumber | Number | No |
| SettingBoolean | Yes/No | No |
| Description | Multiple lines | No |

Recommended records:
- `BusinessDayStartHour` = 8
- `BusinessDayEndHour` = 18
- `StartingSoonMinutes` = 15
- `StatusStaleMinutes` = 12
- `CheckInGraceMinutes` = 10
- `IssueSlaLowHours` = 72
- `IssueSlaMediumHours` = 24
- `IssueSlaHighHours` = 8
- `IssueSlaCriticalHours` = 2
- `FacilitiesEmail` = distribution list
- `AVSupportEmail` = support group
- `IssueManagementEmail` = management escalation group
- `PersistMeetingSubject` = false
- `PersistOrganizer` = false

## 10. CRM_Admins

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| DisplayName | Single line text | No |
| IsActive | Yes/No | Yes |

Use lowercase email address in `Title`. Index `Title`.

This list controls app navigation/UX only. SharePoint permissions remain the real authorization boundary.

## 11. CRM_FlowLog

| Column | Type | Required |
|---|---|---:|
| Title | Single line text | Yes |
| FlowName | Single line text | Yes |
| RunUtc | Date/Time | Yes |
| Status | Choice | Yes |
| RowsProcessed | Number | No |
| ErrorText | Multiple lines | No |
| CorrelationId | Single line text | No |

Status: `Success`, `Partial`, `Failed`.
