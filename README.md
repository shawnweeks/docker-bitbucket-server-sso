### Build Command
```shell
docker build \
    -t registry.cloudbrocktec.com/atlassian-suite/docker-bitbucket-server-sso:7.5.1 \
    --build-arg BITBUCKET_VERSION=7.5.1 \
    .
```

### Push to Registry
```shell
docker push registry.cloudbrocktec.com/atlassian-suite/docker-bitbucket-server-sso
```

### Simple Run Command
```shell
docker run --init -it --rm \
    --name bitbucket  \
    -v bitbucket-data:/var/atlassian/application-data/bitbucket \
    -e JDBC_DRIVER='org.postgresql.Driver' \
    -e JDBC_URL='JDBC_URL_HERE' \
    -e JDBC_USERNAME='JDBC_USERNAME_HERE' \
    -e JDBC_PASSWORD='JDBC_PASSWORD_HERE' \
    -p 7990:7990 \
    -p 7999:7999 \
    registry.cloudbrocktec.com/atlassian-suite/docker-bitbucket-server-sso:7.5.1
```

### SSO Run Command
```shell
# Run first and setup Crowd Directory
docker run --init -it --rm \
    --name bitbucket  \
    -v bitbucket-data:/var/atlassian/application-data/bitbucket \
    -p 7990:7990 \
    -p 7999:7999 \
    -e JDBC_DRIVER='org.postgresql.Driver' \
    -e JDBC_URL='JDBC_URL_HERE' \
    -e JDBC_USERNAME='JDBC_USERNAME_HERE' \
    -e JDBC_PASSWORD='JDBC_PASSWORD_HERE' \
    -e ATL_TOMCAT_CONTEXTPATH='/bitbucket' \
    -e ATL_TOMCAT_SCHEME='https' \
    -e ATL_TOMCAT_SECURE='true' \
    -e ATL_PROXY_NAME='cloudbrocktec.com' \
    -e ATL_PROXY_PORT='443' \
    registry.cloudbrocktec.com/atlassian-suite/docker-bitbucket-server-sso:7.5.1

# Run second after you've setup the crowd connection
docker run --init -it --rm \
    --name bitbucket  \
    -v bitbucket-data:/var/atlassian/application-data/bitbucket \
    -p 7990:7990 \
    -p 7999:7999 \
    -e JDBC_DRIVER='org.postgresql.Driver' \
    -e JDBC_URL='JDBC_URL_HERE' \
    -e JDBC_USERNAME='JDBC_USERNAME_HERE' \
    -e JDBC_PASSWORD='JDBC_PASSWORD_HERE' \
    -e ATL_TOMCAT_CONTEXTPATH='/bitbucket' \
    -e ATL_TOMCAT_SCHEME='https' \
    -e ATL_TOMCAT_SECURE='true' \
    -e ATL_PROXY_NAME='cloudbrocktec.com' \
    -e ATL_PROXY_PORT='443' \
    -e CROWD_SSO_ENABLED='true' \
    -e CUSTOM_SSO_LOGIN_URL='https://cloudbrocktec.com/spring-crowd-sso/saml/login' \
    registry.cloudbrocktec.com/atlassian-suite/docker-bitbucket-server-sso:7.5.1
```

### Environment Variables
| Variable Name | Description | Default Value |
| --- | --- | --- |
| BITBUCKET_SEARCH_ENABLED | Should Bitbucket start an internal ElasticSearch Instance | true |
| JDBC_DRIVER | JDBC Driver Name | org.h2.Driver |
| JDBC_URL | JDBC URL | jdbc:h2:${bitbucket.shared.home}/data/db;MVCC=TRUE;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE;TRACE_LEVEL_FILE=4 |
| JDBC_USERNAME | JDBC Username | sa |
| JDBC_PASSWORD | JDBC Username | None |
| ATL_TOMCAT_PORT | The port bitbucket listens on, this may need to be changed depending on your environment. | 8085 |
| ATL_TOMCAT_SCHEME | The protocol via which bitbucket is accessed | http |
| ATL_TOMCAT_SECURE | Set to true if `ATL_TOMCAT_SCHEME` is 'https' | false |
| ATL_TOMCAT_CONTEXTPATH | The context path the application is served over | None |
| ATL_PROXY_NAME | The reverse proxys full URL for bitbucket | None |
| ATL_PROXY_PORT | The reverse proxy's port number | None |
| CUSTOM_SSO_LOGIN_URL | Login URL for Custom SSO Support | None |
| CROWD_SSO_ENABLED | Enable Crowd SSO Support | false |