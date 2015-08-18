#include <stdio.h>
#include <syslog.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <curl/curl.h>
#include <security/pam_appl.h>
#include <security/pam_modules.h>

#define USERAGENT "pam_eye/1.0"
#define DEFAULT_TIMEOUT_MS 200

#define UNUSED(x) (x)

PAM_EXTERN int pam_sm_close_session(
    pam_handle_t *pamh, int flags, int argc, const char **argv
) {
    UNUSED(pamh);
    UNUSED(flags);
    UNUSED(argc);
    UNUSED(argv);

    return PAM_SUCCESS;
}

PAM_EXTERN int pam_sm_open_session(
    pam_handle_t *pamh, int flags, int argc, const char **argv
) {
    UNUSED(pamh);
    UNUSED(flags);

    if (argc == 0) {
        return PAM_SUCCESS;
    }

    int timeout = DEFAULT_TIMEOUT_MS;
    if (argc >= 2) {
        timeout = atoi(argv[1]);
    }

    int debug = 1;
    if (argc == 3) {
        if (strcmp(argv[2], "nodebug") == 0) {
            debug = 0;
        }
    }

    char report_url[256];
    strncpy(report_url, argv[0], sizeof(report_url) - 1);
    report_url[sizeof(report_url) - 1] = 0;

    char local_hostname[HOST_NAME_MAX + 1];
    gethostname(local_hostname, sizeof(local_hostname) - 1);
    local_hostname[sizeof(local_hostname) - 1] = 0;

    char url[
        strlen("http://") +
        strlen(report_url) +
        strlen("/") +
        strlen(local_hostname) +
        1
    ];

    // required for strcat first call
    url[0] = 0;

    if (!strstr(report_url, "http://") && !strstr(report_url, "https://")) {
        strcpy(url, "http://");
    }

    strcat(url, report_url);
    strcat(url, "/");
    strcat(url, local_hostname);

    CURL *curl = curl_easy_init();
    if (!curl) {
        if (debug) {
            syslog(
                LOG_ERR,
                "[pam_eye] could not initialize curl (curl_easy_init failed)"
            );
        }

        return PAM_SUCCESS;
    }

    curl_easy_setopt(curl, CURLOPT_URL, url);
    curl_easy_setopt(curl, CURLOPT_USERAGENT, USERAGENT);
    curl_easy_setopt(curl, CURLOPT_TIMEOUT_MS, timeout);

    CURLcode result;

    result = curl_easy_perform(curl);
    if (result != CURLE_OK && debug) {
        syslog(
            LOG_ERR,
            "[pam_eye] error while sending logging request to the '%s': %s",
            report_url,
            curl_easy_strerror(result)
        );
    }

    curl_easy_cleanup(curl);

    return PAM_SUCCESS;
}
