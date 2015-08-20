#!/bin/bash

trap pamd_session_restore EXIT
pamd_session_backup

tests_ensure eyed_run ":54321" "$TEST_DIR/reports/"

tests_ensure pamd_session_append "auth   required    /lib/security/pam_eye.so  localhost:54321"

#tests_ensure pamd_session_append "auth     required     pam_eye.so     127.0.0.1:54321"
#tests_ensure pamd_session_append "auth     required     pam_eye.so     `hostname`:54321"

sudo strace -o /tmp/log sudo echo triggering

curl localhost:54321/DEBUG

cat /etc/pam.d/common-auth
cat /etc/pam.d/sudo
cat /etc/pam.d/sudo-l
sudo cat /var/log/syslog
sudo cat /tmp/log

tests_test -f $TEST_DIR/reports/`hostname`

