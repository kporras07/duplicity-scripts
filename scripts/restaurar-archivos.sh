#!/bin/bash
## Remote backup script. Requires duplicity and gpg-agent with the keys and passphrases loaded as root.
## Uses separate encryption and signing keys
## Usage: 'backup_remote.sh'
sign_key=99E6EBAC
enc_key=EBBAB65A
src="/home/vagrant/www/"
dest="ssh://kevin@backups//home/kevin/backups/" #supported file://scp:// ftp:// ftps://, otros

# Keychain is used to source the ssh-agent keys when running from a cron job
type -P keychain &>/dev/null || { echo "I require keychain but it's not installed. Aborting." >&2; exit 1; }
eval `keychain --eval web_rsa` || exit 1
## Note: can't use keychain for gpg-agent because it doesn't currently (2.7.1) read in all the keys correctly..
## Gpg will ask for a passphrase twice for each key...once for encryption/decryption and once for signing..
## This makes unattended backups impossible, especially when trying to resume an interrupted backup.
if [ -f "${HOME}/.gnupg/gpg-agent-info" ]; then
. "${HOME}/.gnupg/gpg-agent-info"
export GPG_AGENT_INFO
fi
duplicity --file-to-restore wp/robots.txt --use-agent \
--verbosity notice \
--encrypt-key "$enc_key" \
--sign-key "$sign_key" \
"$dest" "$src/wp/robots.txt"
