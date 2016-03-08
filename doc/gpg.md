# Creating a gpg-keypair with subkeys

## Creating the keypair
1. `gpg --gen-key` with maximum key size
1. `gpg --edit-key you@domain.tld`

   `setpref SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed`

   `addkey` 'sign only' with maximum key size and lower expiration date

   `save`

1. `gpg --output \<you@domain.tld\>.gpg-revocation-certificate --gen-revoke you@domain.tld`
1. `gpg --export-secret-keys --armor you@domain.tld > \<you@domain.tld\>.private.gpg-key`
1. `gpg --export-secret-subkeys --armor you@domain.tld > \<you@domain.tld\>.subkey.gpg-key`
1. `gpg --export --armor you@domain.tld > \<you@domain.tld\>.public.gpg-key`
1. Put everything in a save storage

## Put key in use (on same machine)
1. Copy `\<you@domain.tld\>.subkey.gpg-key` from your save storage
1. `gpg --delete-secret-key you@domain.tld`
1. `gpg --import \<you@domain.tld\>.subkey.gpg-key`
1. `shred --remove \<you@domain.tld\>.subkey.gpg-key`
1. `gpg --list-secret-keys` should list first key as `sec#`

## Put key in use (on other machine)
1. Copy `\<you@domain.tld\>.subkey.gpg-key` and `\<you@domain.tld\>.public.gpg-key`  from your save storage
1. `gpg --import \<you@domain.tld\>.public.gpg-key \<you@domain.tld\>.subkey.gpg-key`
1. `shred --remove \<you@domain.tld\>.subkey.gpg-key \<you@domain.tld\>.public.gpg-key`
1. `gpg --list-secret-keys` should list first key as `sec#`

## Revoke subkey
1. `gpg --import \<you@domain.tld\>.public.gpg-key \<you@domain.tld\>.private.gpg-key`
1. `gpg --edit-key`

## Extend key
`gpg --edit-key you@domain.tld`

`expire` set new date

`save`

## Archive secret key on paper (needs `paperkey` and `dmtx-utils`)
This needs `paperkey` and `dmtx-utils` installed.
This also needs your secret key (`\<you@domain.tld\>`) in your gpg keyring.

Save:

    #!/bin/bash
    gpg --export-secret-key you@domain.tld | paperkey --output-type raw | split -b 1500 - key-

    for K in key-*; do
        dmtxwrite -e 8 $K > $K.png
    done

Print and savely store

`shred --remove key*`

Restore:
Scan and name as in the export, download your public key

    #!/bin/bash
    for K in key-*; do
        dmtxread
    done
    cat key-*.png.txt > key.txt
    paperkey --pubring public.gpg --secrets key.txt --input-type raw --output secret.gpg
    gpg --import secret.gpg
    shred --remove secret.gpg key*

## TODO
* subkey revocation
* master key revocation

## Sources
* https://alexcabal.com/creating-the-perfect-gpg-keypair/
* https://schnouki.net/posts/2010/03/22/howto-backup-your-gnupg-secret-key-on-paper/
* https://help.riseup.net/en/security/message-security/openpgp/best-practices
