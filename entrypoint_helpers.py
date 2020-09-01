import sys
import os
import shutil
import logging
import jinja2 as j2
import uuid
import base64
from jproperties import Properties

logging.basicConfig(level=logging.DEBUG)

env = {k: v
    for k, v in os.environ.items()}

jenv = j2.Environment(
    loader=j2.FileSystemLoader('/opt/jinja-templates/'),
    autoescape=j2.select_autoescape(['xml']))

def gen_cfg(tmpl, target):
    print(f"Generating {target} from template {tmpl}")
    cfg = jenv.get_template(tmpl).render(env)
    with open(target, 'w') as fd:
        fd.write(cfg)

def set_prop(key, val, target):
    print(f"Setting {key}={val} in {target}")
    matched_key = False
    with open(target, 'r') as f:
        input = f.read()
        with open(target, 'w') as output:        
            for line in input.splitlines():
                if key in line:
                    matched_key = True
                    output.write(f'{key}={val}\n')
                else:
                    output.write(f'{line}\n')
            if not matched_key:
                output.write(f'{key}={val}\n')