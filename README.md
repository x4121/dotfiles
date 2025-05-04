# dotfiles

My dotfiles and installed software

## Contents

The repo contains a bootstrap script to download itself and install Ansible.
The rest of the repository is an Ansible playbook to install and configure everything.

I tried to move all personalized information into `./group_vars/adg.yml` and the host groups in `./inventory`;
but there might still be roles where I was to lazy to extract everything (e.g. `./roles/mutt`).

## Install

- `curl -L https://armingrodon.de/dot | bash` or
- `wget -q -O - https://armingrodon.de/dot | bash`

## Warning

- This project is currently only tested against the most recent\* Ubuntu LTS release
  (if even!)
- The bootstrap script will overwrite files,
  read the Ansible roles in `./roles` if you want to know which.
  The roles are assigned in `./group_vars/all.yml` via `./pre_tasks/role_setup.yml`.
- Use at your own risk!

\* or somewhat recent

## Other stuff

[Dell C1660 installation](docs/Dell_C1660.md)

[GnuPG key generation guide](docs/gpg.md)

[Trackpad deactivation guide](docs/trackpad.md)
