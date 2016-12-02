#!/bin/sh

if command -v dnf > /dev/null; then
    echo "===== Starting postgresql ====="
    sudo su - postgres -c "/usr/libexec/postgresql-ctl restart -D ${PGDATA} -s -w -t ${PGSTARTTIMEOUT}"

    function stop_all() {
        echo "===== Stopping postgresql ====="
        sudo su - postgres -c "/usr/libexec/postgresql-ctl stop -D ${PGDATA} -s -m fast"
    }
else
    echo "===== Starting postgresql ====="
    sudo /etc/init.d/postgresql restart >/dev/null

    function stop_all() {
        echo "===== Stopping postgresql ====="
        sudo /etc/init.d/postgresql stop
    }
fi

trap stop_all HUP INT QUIT KILL TERM

if [ $# -eq 0 ]; then
    /bin/bash
else
    /bin/bash -c "$@"
fi
