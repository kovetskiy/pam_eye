#!/bin/bash

trap pamd_session_restore EXIT
pamd_session_backup

tests_ensure eyed_run ":54321" "$TEST_DIR/reports/"
eyed_bg_id=$(cat `tests_stdout`)
eyed_pid=$(tests_background_pid $eyed_bg_id)

tests_ensure kill -STOP $eyed_pid

# default timeout is 2sec
tests_ensure pamd_session_append "session optional pam_eye.so localhost:54321"

tests_do $(which time) -f '%e' sudo true
time_elapsed=$(cat `tests_stderr`)
tests_test `echo "$time_elapsed > 2.00" | bc` -eq 1

pamd_session_restore
