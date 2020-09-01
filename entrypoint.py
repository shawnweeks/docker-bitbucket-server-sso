#!/usr/bin/python3

from entrypoint_helpers import env, gen_cfg

BITBUCKET_HOME = env['BITBUCKET_HOME']
BITBUCKET_INSTALL_DIR = env['BITBUCKET_INSTALL_DIR']

gen_cfg('bitbucket.properties.j2', f'{BITBUCKET_HOME}/shared/bitbucket.properties')

if 'CROWD_SSO_ENABLED' in env and env['CROWD_SSO_ENABLED'] == 'true':
    gen_cfg('login.soy.j2', f'{BITBUCKET_INSTALL_DIR}/app/static/bitbucket/internal/page/login/login.soy')    