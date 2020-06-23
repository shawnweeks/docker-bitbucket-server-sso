#!/usr/bin/python3

import shutil
from entrypoint_helpers import env, gen_cfg, str2bool, start_app

SSO_ENABLED = env['sso_enabled']

print("Checking for SSO env variable")
if SSO_ENABLED.lower() == 'true':
    print("Copying SSO related files")
    gen_cfg('login.soy.j2', '/opt/atlassian/bitbucket/app/static/bitbucket/internal/page/login/login.soy')
    shutil.copyfile("/opt/atlassian/sso/bitbucket.properties",
                    "/var/atlassian/application-data/bitbucket/shared/bitbucket.properties")
else:
    # Bitbucket seems to enable SSO when Crowd directory is configured.
    # I'm going to leave the enabled properties file just in-case Atlassian breaks it later.
    shutil.copyfile("/opt/atlassian/sso/bitbucket_sso_disabled.properties",
                    "/var/atlassian/application-data/bitbucket/shared/bitbucket.properties")

RUN_USER = env['run_user']
RUN_GROUP = env['run_group']
BITBUCKET_INSTALL_DIR = env['bitbucket_install_dir']
BITBUCKET_HOME = env['bitbucket_home']

start_cmd = f"{BITBUCKET_INSTALL_DIR}/bin/start-bitbucket.sh -fg"
if str2bool(env['elasticsearch_enabled']) is False or env['application_mode'] == 'mirror':
    start_cmd += ' --no-search'

start_app(start_cmd, BITBUCKET_HOME, name='Bitbucket Server')
