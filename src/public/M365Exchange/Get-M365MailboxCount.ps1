function Get-M365MailboxCount {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, Position = 1)] [switch] $UserMailboxes,
        [Parameter(Mandatory = $false, Position = 2)] [switch] $SharedMailboxes,
        [Parameter(Mandatory = $false, Position = 3)] [switch] $RoomMailboxes,
        [Parameter(Mandatory = $false, Position = 4)] [switch] $EquipmentMailboxes,
        [Parameter(Mandatory = $false, Position = 5)] [switch] $DiscoveryMailbox
    )
    Get-ExchangeConnection

    Write-Debug "Getting Exchange Online Mailbox Data"
    if (-not $UserMailboxes -and -not $SharedMailboxes -and -not $RoomMailboxes -and -not $EquipmentMailboxes -and -not $DiscoveryMailbox) { $allType = $true } else { $allType = $false }
    $totalMailboxes = 0
    $output = @()
    $mailboxes = @()
    if ($UserMailboxes -or $allType) {
        Write-Verbose "Getting All User Mailboxes"
        $mailboxes += Get-EXOMailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -eq "UserMailbox" }
    }
    if ($SharedMailboxes -or $allType) {
        Write-Verbose "Getting All Shared Mailboxes"
        $mailboxes += Get-EXOMailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -eq "SharedMailbox" }
    }
    if ($RoomMailboxes -or $allType) {
        Write-Verbose "Getting All Room Mailboxes"
        $mailboxes += Get-EXOMailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -eq "RoomMailbox" }
    }
    if ($EquipmentMailboxes -or $allType) {
        Write-Verbose "Getting All Equipment Mailboxes"
        $mailboxes += Get-EXOMailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -eq "EquipmentMailbox" }
    }
    if ($DiscoveryMailbox -or $allType) {
        Write-Verbose "Getting All Discovery Mailboxes"
        $mailboxes += Get-EXOMailbox -ResultSize Unlimited | Where-Object { $_.RecipientTypeDetails -eq "DiscoveryMailbox" }
    }
    if (-not $allType) {
        Write-Verbose "Getting All Mailboxes"
        $totalMailboxes = (Get-EXOMailbox -ResultSize Unlimited).Count
    }

    $mailboxes | Group-Object -Property RecipientTypeDetails -NoElement | ForEach-Object {
        if ($allType) {
            $totalMailboxes += $_.Count
        }
        $output += New-Object psobject -Property @{ MailboxType = $_.Name; Count = $_.Count }
    }

    $output += New-Object psobject -Property @{ MailboxType = "Total"; Count = $totalMailboxes }
    $output | Select-Object MailboxType, Count
}
Export-ModuleMember -Function Get-M365MailboxCount