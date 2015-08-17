# Installation

## Arch Linux

- Install package:
```
$ git clone https://github.com/kovetskiy/pam_eye
$ cd archlinux
$ makepkg -c
# pacman -U *.xz
```

- Add following lines to `/etc/pam.d/system-auth`:
```
auth    required    pam_eye.so    DOMAIN
```

Replace placeholder `DOMAIN` with your pam_eye gateway host.

## Arch Linux

- Install package:
```
$ git clone https://github.com/kovetskiy/pam_eye
$ cd debian
# apt-get install libcurl4-openssl-dev libpam0g-dev
$ ./build.sh 1.0
# dpkg -i *.deb
```

- Add following lines to `/etc/pam.d/common-auth`:
```
auth    required    pam_eye.so    DOMAIN
```

Replace placeholder `DOMAIN` with your pam_eye gateway host.
