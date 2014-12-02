Requerimientos:

    Duplicity
    gpg-agent
    keychain
    complemento deacuerdo al destino (ssh incluido por default)

Generar gpg key

    gpg --gen-key

Agregar a .bashrc

function gpg_start {
gnupginf="${HOME}/.gnupg/gpg-agent-info"
if pgrep -u "${USER}" gpg-agent >/dev/null 2>&1; then
eval "$(cat $gnupginf)"
eval "$(cut -d= -f1 < $gnupginf | xargs echo export)"
else
eval "$(gpg-agent -s --daemon --write-env-file $gnupginf)"
fi
}
function keys {
touch test-gpg.txt
touch test-gpg.txt1
gpg -r 'Duplicity Encryption Key' -e test-gpg.txt
gpg -r 'Duplicity Signature Key' -e test-gpg.txt1
gpg -u --detach-sign test-gpg.txt
gpg -u --detach-sign test-gpg.txt1
gpg <signing key> -d test-gpg.txt.gpg
gpg <enc key> -d test-gpg.txt1.gpg
rm test-gpg.txt*
}

gpg_start


ATENCION:
Por bug en versi√n en repo de Ubuntu 12.04; agregar el ppa e instalar desde ah√:

Repo:

deb http://ppa.launchpad.net/duplicity-team/ppa/ubuntu precise main
deb-src http://ppa.launchpad.net/duplicity-team/ppa/ubuntu precise main
