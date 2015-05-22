#!/bin/sh

hg clone -q https://hg.python.org/tracker/roundup
# hg clone -q https://bitbucket.org/introom/cpython-roundup roundup
(cd roundup; hg up -q bugs.python.org)

hg clone -q https://hg.python.org/tracker/python-dev python-dev
(cd python-dev;
mkdir db; echo postgresql > db/backend_name;
cp config.ini.template config.ini
cp detectors/config.ini.template detectors/config.ini
)
