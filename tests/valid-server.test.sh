#!/bin/bash

trap pamd_session_restore EXIT
pamd_session_backup

tests_ensure eyed_run ":54321" "$TEST_DIR/reports/"

tests_ensure pamd_session_append "session optional pam_eye.so  localhost:54321"

sudo echo trigger pam

tests_test -f $TEST_DIR/reports/`hostname`

pamd_session_restore
