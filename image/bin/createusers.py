"""
Create 3 users in the db:
* user: a regular user
* developer: a developer (triager) that signed the cla
* coordinator: a coordinator and committer that signed the cla

Most of the fields are the same as the username.
The password for all the users is 'pass'.
"""

import subprocess

rdadmin = ['/home/tracker/bin/roundup-admin', '-i', '/opt/tracker/python-dev']

users = ['user', 'developer', 'coordinator']
roles = []

for user in users:
    roles.append(user.capitalize())
    r = ','.join(roles)
    ic = 1 if user == 'coordinator' else 0  # only coord is committer
    args = ('create user username={u} address={u}@bugs.python.org '
            'password=pass realname={u} github={u} roles={r} '
            'iscommitter={ic}'.format(u=user, r=r, ic=ic))
    if user in {'developer', 'coordinator'}:
        args += ' contrib_form=1 contrib_form_date=2017-03-22.00:00:00'

    print('Creating user:', user)
    print('    - user id:', end=' ', flush=True)
    subprocess.run(rdadmin + args.split())
