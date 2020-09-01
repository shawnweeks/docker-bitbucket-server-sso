# Atlassian Docker UIDs
# These are based on the UIDs found in the Official Images
# to maintain compatability as much as possible.
# Jira          2001
# Confluence    2002
# Bitbucket     2003
# Crowd         2004
# Bamboo        2005

ARG BASE_REGISTRY=registry.cloudbrocktec.com
ARG BASE_IMAGE=redhat/ubi/ubi8
ARG BASE_TAG=8.2

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV BITBUCKET_USER bitbucket
ENV BITBUCKET_GROUP bitbucket
ENV BITBUCKET_UID 2003
ENV BITBUCKET_GID 2003

ENV BITBUCKET_HOME /var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR /opt/atlassian/bitbucket

ARG BITBUCKET_VERSION
ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/stash/downloads/atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz

RUN yum install -y java-11-openjdk-devel procps git python3 python3-jinja2 && \
    yum clean all

COPY [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "/tmp/scripts/" ]

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]

RUN mkdir -p ${BITBUCKET_HOME}/shared && \
    mkdir -p ${BITBUCKET_INSTALL_DIR} && \
    groupadd -r -g ${BITBUCKET_GID} ${BITBUCKET_GROUP} && \
    useradd -r -u ${BITBUCKET_UID} -g ${BITBUCKET_GROUP} -M -d ${BITBUCKET_HOME} ${BITBUCKET_USER} && \
    curl --silent -L ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$BITBUCKET_INSTALL_DIR" && \
    chown -R "${BITBUCKET_USER}:${BITBUCKET_GROUP}" "${BITBUCKET_INSTALL_DIR}" && \
    cp /tmp/scripts/* ${BITBUCKET_INSTALL_DIR}/bin && \
    chown -R "${BITBUCKET_USER}:${BITBUCKET_GROUP}" "${BITBUCKET_HOME}" && \
    chmod 755 ${BITBUCKET_INSTALL_DIR}/bin/entrypoint.*

EXPOSE 7990
EXPOSE 7999

VOLUME ${BITBUCKET_HOME}
USER ${BITBUCKET_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-11
ENV PATH=${PATH}:${BITBUCKET_INSTALL_DIR}/bin
WORKDIR ${BITBUCKET_HOME}
ENTRYPOINT [ "entrypoint.sh" ]