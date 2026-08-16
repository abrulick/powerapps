param(
    [Parameter(Mandatory=$true)]
    [string]$MonitorAccount,

    [Parameter(Mandatory=$false)]
    [string]$RoomCsv
)

# Connect-ExchangeOnline before running this script.
# CSV format: RoomEmail
# room1@contoso.com
# room2@contoso.com

if ($RoomCsv) {
    $rooms = Import-Csv $RoomCsv
} else {
    $rooms = Get-ExoMailbox -RecipientTypeDetails RoomMailbox -ResultSize Unlimited |
        Select-Object @{N="RoomEmail";E={$_.PrimarySmtpAddress.ToString()}}
}

foreach ($room in $rooms) {
    $identity = "$($room.RoomEmail):\Calendar"
    $existing = Get-MailboxFolderPermission -Identity $identity -User $MonitorAccount -ErrorAction SilentlyContinue

    if ($existing) {
        Set-MailboxFolderPermission -Identity $identity -User $MonitorAccount -AccessRights Reviewer
        Write-Host "Updated Reviewer: $identity"
    } else {
        Add-MailboxFolderPermission -Identity $identity -User $MonitorAccount -AccessRights Reviewer
        Write-Host "Added Reviewer: $identity"
    }
}
