#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

startup() {
    echo Starting Bitbucket Server
    if [[ ${BITBUCKET_SEARCH_ENABLED} = false ]]
    then
        ${BITBUCKET_INSTALL_DIR}/bin/start-bitbucket.sh --no-search
    else
        ${BITBUCKET_INSTALL_DIR}/bin/start-bitbucket.sh
    fi
    sleep 15
    tail -n +1 --retry -F ${BITBUCKET_HOME}/log/*.log ${BITBUCKET_HOME}/log/**/*.log
}

shutdown() {
    echo Stopping Bitbucket Server
    ${BITBUCKET_INSTALL_DIR}/bin/stop-bitbucket.sh
}

trap "shutdown" INT
entrypoint.py
startup