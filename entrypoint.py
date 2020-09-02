#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg, set_props

BITBUCKET_HOME = env['BITBUCKET_HOME']
BITBUCKET_INSTALL_DIR = env['BITBUCKET_INSTALL_DIR']

props = {
    "plugin.auth-crowd.sso.enabled":env.get("CROWD_SSO_ENABLED","false"),
    "server.secure":env.get("ATL_TOMCAT_SECURE","false"),
    "server.scheme":env.get("ATL_TOMCAT_SCHEME","http"),
    "server.proxy-port":env.get("ATL_PROXY_PORT",""),
    "server.proxy-name":env.get("ATL_PROXY_NAME",""),
    "server.context-path":env.get("ATL_TOMCAT_CONTEXTPATH",""),
}

set_props(props,f'{BITBUCKET_HOME}/shared/bitbucket.properties')

if 'CROWD_SSO_ENABLED' in env and env['CROWD_SSO_ENABLED'] == 'true':
    gen_cfg('login.soy.j2', f'{BITBUCKET_INSTALL_DIR}/app/static/bitbucket/internal/page/login/login.soy')    