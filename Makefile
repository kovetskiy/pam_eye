all:
	gcc -fPIC -c pam_eye.c
	ld -lcurl -x --shared -o pam_eye.so pam_eye.o

install:
	install -D pam_eye.so /use/lib/security/pam_eye.so
