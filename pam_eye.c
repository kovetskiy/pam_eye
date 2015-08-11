#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <curl/curl.h>
#include <security/pam_appl.h>
#include <security/pam_modules.h>

#define USERAGENT "pam_eye/1.0"
#define TIMEOUT   10L

PAM_EXTERN int pam_sm_setcred(
    pam_handle_t *pamh, int flags, int argc, const char **argv
) {
	return PAM_SUCCESS ;
}

PAM_EXTERN int pam_sm_authenticate(
    pam_handle_t *pamh, int flags,int argc, const char **argv
) {
    if (argc == 0) {
        return PAM_SUCCESS;
    }

    char host[256];
    strncpy(host, argv[0], 256);

    char hostname[256];
    gethostname(hostname, 256);

    // +7 for 'http://', +1 for '/'
    char url[strlen(host) + strlen(hostname) + 7 + 1];
    strcpy(url, "http://");
    strcat(url, host);
    strcat(url, "/");
    strcat(url, hostname);

    CURL *curl = curl_easy_init();
    if (!curl) {
        return PAM_SUCCESS;
    }

    CURLcode res;
    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, USERAGENT);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT, TIMEOUT);
    curl_easy_perform(curl);
    curl_easy_cleanup(curl);

    return PAM_SUCCESS ;
}
