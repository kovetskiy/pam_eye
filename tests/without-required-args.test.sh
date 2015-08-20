#!/bin/bash

trap pamd_session_restore EXIT
pamd_session_backup

tests_ensure pamd_session_append "session optional pam_eye.so"

tests_ensure sudo echo "test passed"
