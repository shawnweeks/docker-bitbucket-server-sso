#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"




if [[ ! -d ${BITBUCKET_HOME}/shared ]]
then
  mkdir ${BITBUCKET_HOME}/shared/
  touch ${BITBUCKET_HOME}/shared/bitbucket.properties
elif [[ ! -e ${BITBUCKET_HOME}/shared/bitbucket.properties ]]
then
    touch ${BITBUCKET_HOME}/shared/bitbucket.properties
fi

entrypoint.py
${BITBUCKET_INSTALL_DIR}/bin/start-bitbucket.sh -fg --no-search