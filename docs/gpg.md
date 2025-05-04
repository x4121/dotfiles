# Creating a gpg-keypair

## Creating the keypair

1. `gpg --gen-key` with maximum key size
1. `gpg --output you@domain.tld.gpg-revocation-certificate --gen-revoke you@domain.tld`
1. `gpg --export-secret-keys --armor you@domain.tld > you@domain.tld.gpg-private-key`
1. `gpg --export --armor you@domain.tld > you@domain.tld.gpg-public-key`
1. `gpg --keyserver pgp.mit.edu --send-keys you@domain.tld`
1. Put everything in a save storage

## Put key in use (on other machine)

1. Copy `you@domain.tld.gpg-private-key` and `you@domain.tld.gpg-public-key`
  from your save storage
1. `gpg --import you@domain.tld.gpg-private-key you@domain.tld.gpg-public-key`
1. `shred --remove you@domain.tld.gpg-private-key you@domain.tld.gpg-public-key`

## Revoke keypair

1. `gpg --import you@domain.tld.gpg-revocation-certificate`
1. `gpg --keyserver pgp.mit.edu --send-keys you@domain.tld`

## Extend key

`gpg --edit-key you@domain.tld`

`expire` set new date

`save`
