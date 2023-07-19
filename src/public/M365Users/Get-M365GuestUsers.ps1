function Get-M365GuestUsers {
    [CmdletBinding()]
    param()
    if (Get-Module -ListAvailable -Name MSOnline) { Import-Module MSOnline } else { Install-Module -Name MSOnline }
    $testConnection = Get-MsolDomain -ErrorAction SilentlyContinue
    If (-not $testConnection) { Connect-MsolService }
    $output = @()
    Get-MsolUser -All | Where-Object { $_.UserType -eq "Guest" } | ForEach-Object {
        $output += New-Object -TypeName psobject -Property @{
            EmailAddress = $_.SignInName
            DisplayName = $_.DisplayName
            FirstName = $_.FirstName
            LastName = $_.LastName
            Title = $_.Title
            Department = $_.Department
            WhenCreated = $_.WhenCreated
        }
    }
    $output
    return
}
Export-ModuleMember -Function Get-M365GuestUsers