function Set-M365MFAUsers {
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory = $true)]
        [string[]] $Users, 
        [Parameter(Mandatory)]
        [ValidateSet("Enabled","Enforced")]
        $State
    )
    if (Get-Module -ListAvailable -Name MSOnline) { Import-Module MSOnline } else { Install-Module -Name MSOnline }
    $testConnection = Get-MsolDomain -ErrorAction SilentlyContinue
    If (-not $testConnection) { Connect-MsolService }
    Set-Location $PSScriptRoot
    $st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
    $st.RelyingParty = "*"
    $st.State = $State
    $sta = @($st)

    $Users | ForEach-Object {
        Try {
            Write-Host -nonewline "Setting MFA to $($State) for $($_)"
            Set-MsolUser -StrongAuthenticationRequirements $sta -UserPrincipalName $_
            Write-Host -f Green " .....Done!"
        }
        Catch {
            Write-Host -f Red " .....Error!"
        }
    }
}
Export-ModuleMember -Function Set-M365MFAUsers