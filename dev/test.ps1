
Import-Module C:\dev\ps\modules\M365Toolbox\src\M365.Toolbox.psm1 -Verbose
Get-Module | Where-Object { $_.Name -eq "M365.Toolbox" }
Remove-Module M365.Toolbox