function Get-ExchangeConnection {  
    Write-Debug "Adding Exchange Online Module"
    $module = Get-Module | Where-Object { $_.Name -eq "ExchangeOnlineManagement" }
    If (-not ($module)) {
        Import-Module ExchangeOnlineManagement
    }

    Write-Debug "Connecting to Exchange Online"
    $getsessions = Get-PSSession | Select-Object -Property State, Name
    $isconnected = (@($getsessions) -like '@{State=Opened; Name=ExchangeOnlineInternalSession*').Count -gt 0
    If (-not ($isconnected)) {
        Connect-ExchangeOnline
    }
}