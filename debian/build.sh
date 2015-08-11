#!/bin/bash

set -e -u

if [ $# -eq 0 ]; then
    echo -e "Usage:\n$0 <version>"
    exit 1
fi

VERSION="$1"
PKGDIR="pam_eye-deb"
SRCDIR="src"

sed -i 's/\$VERSION\$/'$VERSION'/g' $PKGDIR/DEBIAN/control

git clone https://github.com/kovetskiy/pam_eye $SRCDIR

cd $SRCDIR
make
install -D "pam_eye.so" "$PKGDIR/usr/lib/security/pam_eye.so"

dpkg -b $PKGDIR pam_eye-${VERSION}_amd64.deb

# restore version placeholder
git checkout $PKGDIR
