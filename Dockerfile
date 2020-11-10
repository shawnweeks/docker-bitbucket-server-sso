# Atlassian Docker UIDs
# These are based on the UIDs found in the Official Images
# to maintain compatability as much as possible.
# Jira          2001
# Confluence    2002
# Bitbucket     2003
# Crowd         2004
# Bamboo        2005
ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi7
ARG BASE_TAG=7.9

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG} as build

ARG BITBUCKET_VERSION
ARG BITBUCKET_PACKAGE=atlassian-bitbucket-${BITBUCKET_VERSION}.tar.gz

COPY [ "${BITBUCKET_PACKAGE}", "/tmp/" ]

RUN mkdir -p /tmp/atl_pkg && \
    tar -xf /tmp/${BITBUCKET_PACKAGE} -C "/tmp/atl_pkg" --strip-components=1


###############################################################################
ARG BASE_REGISTRY
ARG BASE_IMAGE=redhat/ubi/ubi7
ARG BASE_TAG=7.9

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV BITBUCKET_USER bitbucket
ENV BITBUCKET_GROUP bitbucket
ENV BITBUCKET_UID 2003
ENV BITBUCKET_GID 2003

ENV BITBUCKET_HOME /var/atlassian/application-data/bitbucket
ENV BITBUCKET_INSTALL_DIR /opt/atlassian/bitbucket

RUN yum install -y java-11-openjdk-devel procps git python2 python2-jinja2 && \
    yum clean all && \    
    mkdir -p ${BITBUCKET_HOME} && \
    mkdir -p ${BITBUCKET_INSTALL_DIR} && \
    groupadd -r -g ${BITBUCKET_GID} ${BITBUCKET_GROUP} && \
    useradd -r -u ${BITBUCKET_UID} -g ${BITBUCKET_GROUP} -M -d ${BITBUCKET_HOME} ${BITBUCKET_USER} && \
    chown ${BITBUCKET_USER}:${BITBUCKET_GROUP} ${BITBUCKET_HOME} && \
    chown ${BITBUCKET_USER}:${BITBUCKET_GROUP} ${BITBUCKET_INSTALL_DIR}

COPY [ "templates/*.j2", "/opt/jinja-templates/" ]
COPY --from=build --chown=${BITBUCKET_USER}:${BITBUCKET_GROUP} [ "/tmp/atl_pkg", "${BITBUCKET_INSTALL_DIR}/" ]
COPY --chown=${BITBUCKET_USER}:${BITBUCKET_GROUP} [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "${BITBUCKET_INSTALL_DIR}/" ]


RUN chmod 755 ${BITBUCKET_INSTALL_DIR}/entrypoint.*

EXPOSE 7990
EXPOSE 7999

VOLUME ${BITBUCKET_HOME}
USER ${BITBUCKET_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-11
ENV PATH=${PATH}:${BITBUCKET_INSTALL_DIR}
WORKDIR ${BITBUCKET_HOME}
ENTRYPOINT [ "entrypoint.sh" ]