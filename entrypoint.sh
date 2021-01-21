#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

shutdownCleanup() {
    if [[ -f ${HOME}/.lock ]]
    then
        echo "Cleaning Up Bitbucket Locks"
        rm ${HOME}/.lock
    fi
}

entrypoint.py
trap "shutdownCleanup" INT
${BITBUCKET_INSTALL_DIR}/bin/start-bitbucket.sh -fg