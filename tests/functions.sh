#!/bin/bash

pamd_session_backup() {
    echo backuping "/etc/pam.d/common-auth" to "$TEST_DIR/common-auth"
    sudo cp "/etc/pam.d/common-auth" "$TEST_DIR/common-auth"
}

pamd_session_restore() {
    echo restoring "$TEST_DIR/common-auth" to "/etc/pam.d/common-auth"
    sudo cp "$TEST_DIR/common-auth" "/etc/pam.d/common-auth"
}

pamd_session_append() {
    local content="$1"

    echo "$content" | sudo tee --append "/etc/pam.d/common-auth"
}

eyed_run() {
    local listen="$1"
    local directory="$2"

    tests_debug "running eyed server on $listen"

    local bg_id=`tests_background "$EYED_BIN -l $listen -d $directory"`
    local bg_pid=`tests_background_pid $bg_id`

    # 10 seconds
    local check_max=100
    local check_counter=0

    while true; do
        sleep 0.1

        if ! kill -0 $bg_pid; then
            tests_debug "eyed has gone away..."
            exit 1
        fi

        grep -q "$listen" <<< "`netstat -vatn`"
        local grep_result=$?
        if [ $grep_result -eq 0 ]; then
            break
        fi

        check_counter=$(($check_counter+1))
        if [ $check_counter -ge $check_max ]; then
            tests_debug "eyed not started listening on $listen"
            exit 1
        fi
    done

    echo $bg_id
}
