#!/bin/bash

if [[ "$1" != "-f" ]]; then
    echo
    echo WARNING! WARNING! WARNING! WARNING!
    echo Tests should be runned in container.
    echo
    echo Run tests on local machine at your own risk.
    echo
    echo Add -f to run the tests.
    echo

    exit 1
fi

EYED_BIN="$(which eyed 2>/dev/null)"
if [ $? -ne 0 ]; then
    echo "eyed is not installed"
    echo "http://github.com/kovetskiy/eyed"
    exit 1
fi

make
if [ $? -ne 0 ]; then
    echo "can't build module"
    exit 1
fi

sudo make install
if [ $? -ne 0 ]; then
    echo "can't install module"
    exit 1
fi

# bash tests library
if [ ! -f tests/lib/tests.sh ]; then
    git submodule init
    git submodule update

    if [ ! -f tests/lib/tests.sh ]; then
        echo "file 'tests/lib/tests.sh' not found"
        exit 1
    fi
fi

source tests/lib/tests.sh
source tests/functions.sh

cd tests
TEST_VERBOSE=10
tests_run_all
