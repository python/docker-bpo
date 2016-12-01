#!/bin/sh

echo "===== Downloading roundup sources ====="
hg clone -q https://hg.python.org/tracker/roundup
(
    cd roundup;
    hg up -q bugs.python.org
)

echo "===== Downloading python-dev sources ====="
hg clone -q https://hg.python.org/tracker/python-dev python-dev
(
    cd python-dev;
    mkdir db; echo postgresql > db/backend_name;
    cp config.ini.template config.ini
    cp detectors/config.ini.template detectors/config.ini
)

echo "===== All downloads finished successfully ====="
