Get-Mailbox -ResultSize Unlimited | Where-Object { $_.ForwardingAddress -ne $null } | Select-Object UserPrincipalName, @{Name = 'ForwardingAddress'; Expression = { 
        $mailbox = (Get-Mailbox -Identity $_.ForwardingAddress).PrimarySmtpAddress
        if (!$mailbox) {
            $mailUser = (Get-MailUser -Identity $_.ForwardingAddress).PrimarySmtpAddress
            $mailUser
        }
        else {
            $mailbox
        }
    }
} | FT -AutoSize
#ForwardingSmtpAddress
