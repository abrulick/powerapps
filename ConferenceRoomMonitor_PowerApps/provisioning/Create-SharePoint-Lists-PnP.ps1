<#
OPTIONAL helper. Review before use.
Requires PnP.PowerShell and appropriate SharePoint permissions.
Creates lists and a subset of simple fields. Complete choice/person/multiline fields
from docs/01-SharePoint-Schema.md.
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SiteUrl
)

Connect-PnPOnline -Url $SiteUrl -Interactive

$lists = @(
    "CRM_Rooms",
    "CRM_RoomStatus",
    "CRM_RoomDailyMetrics",
    "CRM_RoomRollingMetrics",
    "CRM_EstateDailyMetrics",
    "CRM_CheckIns",
    "CRM_Feedback",
    "CRM_Issues",
    "CRM_Settings",
    "CRM_Admins",
    "CRM_FlowLog"
)

foreach ($list in $lists) {
    if (-not (Get-PnPList -Identity $list -ErrorAction SilentlyContinue)) {
        New-PnPList -Title $list -Template GenericList -OnQuickLaunch:$false
    }
}

function Add-FieldIfMissing($List, $Name, $Type) {
    if (-not (Get-PnPField -List $List -Identity $Name -ErrorAction SilentlyContinue)) {
        Add-PnPField -List $List -DisplayName $Name -InternalName $Name -Type $Type -AddToDefaultView
    }
}

# CRM_Rooms
"RoomEmail","RoomListEmail","CalendarId","Floor","SupportGroupEmail" |
    ForEach-Object { Add-FieldIfMissing "CRM_Rooms" $_ "Text" }
"Capacity","SortOrder" |
    ForEach-Object { Add-FieldIfMissing "CRM_Rooms" $_ "Number" }
"IsActive","OutOfService","HasTeamsRoom","HasDisplay","HasCamera","HasWhiteboard","HasHDMI","HasUSB-C","HasWirelessShare" |
    ForEach-Object { Add-FieldIfMissing "CRM_Rooms" $_ "Boolean" }
Add-FieldIfMissing "CRM_Rooms" "LastDirectorySyncUtc" "DateTime"

# CRM_CheckIns
"CheckInKey","RoomEmail","EventReference" |
    ForEach-Object { Add-FieldIfMissing "CRM_CheckIns" $_ "Text" }
"BookingStartUtc","BookingEndUtc","CheckInUtc" |
    ForEach-Object { Add-FieldIfMissing "CRM_CheckIns" $_ "DateTime" }

# CRM_Admins
Add-FieldIfMissing "CRM_Admins" "DisplayName" "Text"
Add-FieldIfMissing "CRM_Admins" "IsActive" "Boolean"

Write-Host "Base lists/simple fields created."
Write-Host "Complete schema, choices, person fields, multiline fields, required flags, and indexes from docs/01-SharePoint-Schema.md."
