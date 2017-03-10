#!/bin/bash

echo "===== Starting postgresql ====="
sudo /etc/init.d/postgresql restart >/dev/null

function stop_all() {
    echo "===== Stopping postgresql ====="
    sudo /etc/init.d/postgresql stop
}

trap stop_all HUP INT QUIT KILL TERM

if [ $# -eq 0 ]; then
    /bin/bash
else
    /bin/bash -c "$@"
fi
