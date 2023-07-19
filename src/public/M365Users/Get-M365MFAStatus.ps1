function Get-M365MFAStatus {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $false, Position = 1)] [switch] $IsEnabled,
        [Parameter(Mandatory = $false, Position = 2)] [switch] $IsDisabled,
        [Parameter(Mandatory = $false, Position = 3)] [switch] $IsMember,
        [Parameter(Mandatory = $false, Position = 4)] [switch] $IsGuest
    )
    if (-not $IsEnabled -and -not $IsDisabled) { $AllStatus = $true } else { $AllStatus = $false }
    if (-not $IsMember -and -not $IsGuest) { $AllType = $true } else { $AllType = $false }

    if (Get-Module -ListAvailable -Name MSOnline) { Import-Module MSOnline } else { Install-Module -Name MSOnline }
    $testConnection = Get-MsolDomain -ErrorAction SilentlyContinue
    If (-not $testConnection) { Connect-MsolService }
    $output = @()
      Get-MsolUser -All | ForEach-Object {
          $user = $_
        if ((($IsEnabled -and $user.StrongAuthenticationRequirements[0].State) `
            -or ($IsDisabled -and -not $user.StrongAuthenticationRequirements[0].State) `
            -or ($AllStatus)) `
            -and ($IsMember -and $user.UserType -eq "Member") `
            -or ($IsGuest -and $user.UserType -eq "Guest") `
            -or ($AllType)){
            $obj = New-Object -TypeName psobject -Property @{
                UserPrincipalName = $user.UserPrincipalName
                DisplayName = $user.DisplayName
                UserType = $user.UserType
                isLicensed = $user.isLicensed
                MFAStatus = (& { If ($user.StrongAuthenticationRequirements) { $user.StrongAuthenticationRequirements[0].State } Else { "Disable" } })
                MFAMethod = (& { If ($user.StrongAuthenticationMethods) { ($user.StrongAuthenticationMethods | Where-Object { $_.IsDefault -eq $true}).MethodType } Else { "None" } })
            }

            $output += $obj
        }
    }
    $output | Select-Object UserPrincipalName, DisplayName, UserType, isLicensed, MFAStatus, MFAMethod
    return 
}
Export-ModuleMember -Function Get-M365MFAStatus