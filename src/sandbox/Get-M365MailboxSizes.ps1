Get-Mailbox -ResultSize Unlimited | Select-Object UserPrincipalName, DisplayName, RecipientTypeDetails, ProhibitSendReceiveQuota, @{Name = 'TotalItemSize'; Expression = { (Get-EXOMailboxStatistics $_.UserPrincipalName).TotalItemSize}}