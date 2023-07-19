#$AdminSiteURL="https://<your tenant name>-admin.sharepoint.com"
#Connect to SharePoint Online Admin Site
#Connect-SPOService -Url $AdminSiteURL

#Get-SPOSite -IncludePersonalSite $true -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'" | Select-Object Title, Owner, @{Name = 'StorageQuota'; Expression = { "{0:0.00}" -f (Convert-Size -From MB -To GB -Value $_.StorageQuota) }  }, @{Name = 'StorageUsageCurrent'; Expression = { "{0:0.00}" -f (Convert-Size -From MB -To GB -Value $_.StorageUsageCurrent) } } | Sort-Object StorageUsageCurrent -Descending | Export-CSV "C:\temp\HRSD\OneDrive-for-Business-Size-Report.csv" -NoTypeInformation -Encoding UTF8