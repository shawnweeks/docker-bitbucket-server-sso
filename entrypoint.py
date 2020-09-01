#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg, set_prop

BITBUCKET_HOME = env['BITBUCKET_HOME']
BITBUCKET_INSTALL_DIR = env['BITBUCKET_INSTALL_DIR']

pf=f'{BITBUCKET_HOME}/shared/bitbucket.properties'
set_prop("plugin.auth-crowd.sso.enabled", env.get("CROWD_SSO_ENABLED","false"), pf)
set_prop("server.secured", env.get("ATL_TOMCAT_SECURE","false"), pf)
set_prop("server.scheme", env.get("ATL_TOMCAT_SCHEME","http"), pf)
set_prop("server.proxy-port", env.get("ATL_PROXY_PORT",""), pf)
set_prop("server.proxy-name", env.get("ATL_PROXY_NAME",""), pf)
set_prop("server.context-path", env.get("ATL_TOMCAT_CONTEXTPATH",""), pf)

if 'CROWD_SSO_ENABLED' in env and env['CROWD_SSO_ENABLED'] == 'true':
    gen_cfg('login.soy.j2', f'{BITBUCKET_INSTALL_DIR}/app/static/bitbucket/internal/page/login/login.soy')    