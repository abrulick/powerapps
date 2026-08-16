param(
    [Parameter(Mandatory=$true)]
    [string]$MonitorAccount
)

$rooms = Get-ExoMailbox -RecipientTypeDetails RoomMailbox -ResultSize Unlimited

$results = foreach ($room in $rooms) {
    $identity = "$($room.PrimarySmtpAddress):\Calendar"
    $perm = Get-MailboxFolderPermission -Identity $identity -User $MonitorAccount -ErrorAction SilentlyContinue
    [pscustomobject]@{
        Room = $room.DisplayName
        RoomEmail = $room.PrimarySmtpAddress
        Monitor = $MonitorAccount
        AccessRights = if ($perm) { ($perm.AccessRights -join ",") } else { "NONE" }
    }
}

$results | Sort-Object Room | Format-Table -AutoSize
