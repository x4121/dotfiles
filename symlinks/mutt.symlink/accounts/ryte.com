# vim: ft=muttrc:
set from      = "a.grodon@ryte.com"
set signature = "~/.mutt/accounts/ryte.com.sig"

set folder    = "~/Mail/ryte.com"
set spoolfile = "+INBOX"
set record    = "+sent"
set postponed = "+draft"
set trash     = "+trash"
