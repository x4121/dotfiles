# vim: ft=muttrc:
set from      = "armin.grodon@gmail.com"
unset signature

set folder    = "~/Mail/gmail.com"
set spoolfile = "+INBOX"
set record    = "+sent"
set postponed = "+draft"
set trash     = "+trash"
