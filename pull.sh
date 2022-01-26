#!/bin/sh

echo "===== Downloading roundup sources ====="
git clone git@github.com:psf/bpo-roundup roundup
(
    cd roundup
    git checkout bugs.python.org
)

echo "===== Downloading python-dev sources ====="
git clone git@github.com:psf/bpo-tracker-cpython python-dev
(
    cd python-dev
    mkdir db
    cp config.ini.template config.ini
    cp detectors/config.ini.template detectors/config.ini
)

echo "===== All downloads finished successfully ====="
