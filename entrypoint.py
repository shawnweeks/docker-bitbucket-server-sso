#!/usr/bin/python2

from entrypoint_helpers import env, gen_cfg, set_props

BITBUCKET_HOME = env['BITBUCKET_HOME']
BITBUCKET_INSTALL_DIR = env['BITBUCKET_INSTALL_DIR']

props = {
    "plugin.auth-crowd.sso.enabled":env.get("ATL_CROWD_SSO_ENABLED","false"),
    "server.port":env.get("ATL_TOMCAT_PORT","7990"),
    "server.ssl.enabled":env.get("ATL_TOMCAT_SSL_ENABLED","false"),
    "server.ssl.key-alias":env.get("ATL_TOMCAT_KEY_ALIAS","tomcat"),
    "server.ssl.key-store":env.get("ATL_TOMCAT_KEYSTORE_FILE",""),
    "server.ssl.key-store-password":env.get("ATL_TOMCAT_KEYSTORE_PASSWORD",""),
    "server.ssl.key-store-type":env.get("ATL_TOMCAT_KEYSTORE_TYPE","JKS"),
    "server.secure":env.get("ATL_TOMCAT_SECURE","false"),
    "server.ssl.protocol":env.get("ATL_TOMCAT_SSL_ENABLED_PROTOCOLS","TLSv1.2"),
    "server.scheme":env.get("ATL_TOMCAT_SCHEME","http"),
    "server.proxy-port":env.get("ATL_TOMCAT_PROXY_PORT",""),
    "server.proxy-name":env.get("ATL_TOMCAT_PROXY_NAME",""),
    "server.context-path":env.get("ATL_TOMCAT_CONTEXTPATH",""),
}

set_props(props,'{}/shared/bitbucket.properties'.format(BITBUCKET_HOME))

if 'ATL_CROWD_SSO_ENABLED' in env and env['ATL_CROWD_SSO_ENABLED'] == 'true':
    gen_cfg('login.soy.j2', '{}/app/static/bitbucket/internal/page/login/login.soy'.format(BITBUCKET_INSTALL_DIR))    