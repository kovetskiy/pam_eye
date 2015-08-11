#!/bin/bash

gcc -fPIC -c pam_eye.c
ld -lcurl -x --shared -o pam_eye.so pam_eye.o
