# pam_eye

**pam_eye** will log successfully opened sessions by sending simple
GET-requests on the specified server. Information sent will contain no private
information, only hostname of the machine where session has been opened.

**pam_eye** will not block authentication in any way, even if server is
unreachable.

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
session    optional    pam_eye.so    URL [TIMEOUT_MS [nodebug]]
```

Replace placeholder `URL` with your **pam_eye** report server url.

`TIMEOUT_MS` is the maximum amount of milliseconds which **pam_eye** could take.
By default it's 2000 milliseconds.

`nodebug` option can be used to prevent logging to syslog about faulty servers.

## Debian (tested on Ubuntu 10.04 LTS)

- Install package:
```
$ git clone https://github.com/kovetskiy/pam_eye
$ cd debian
# apt-get install libcurl4-openssl-dev libpam0g-dev
$ ./build.sh 1.0
# dpkg -i *.deb
```

- Add following lines to `/etc/pam.d/common-session`:
```
session    optional    pam_eye.so    URL [TIMEOUT [nodebug]]
```

Replace placeholder `URL` with your **pam_eye** report server url.

`TIMEOUT_MS` is the maximum amount of milliseconds which **pam_eye** could take.
By default it's 2000 milliseconds.

`nodebug` option can be used to prevent logging to syslog about faulty servers.

# Tips and tricks

Anything returned from remote server will be echoed back to client, so it's
possible to send some message to user using **pam_eye**.

## Example:

Configure module as following:
```
session    optional    pam_eye.so    localhost:12345 60000
```

Open two consoles.

In the first console run `nc -vlp 12345`.

In the second one run `sudo true`; command should hang for 60s.

Return to `nc` console (you should see incoming request made by **pam_eye**).
Type `I'm watching!`, hit `ENTER` and `CTRL-D`.

`sudo` console should unhang now and you should see message you're typed as
reply.

Valid HTTP status like `200 OK` will, of course, not be replied to client.

***

Thanks to Stanislav Seletskiy ([@seletskiy](https://github.com/seletskiy)) for big contribution.
