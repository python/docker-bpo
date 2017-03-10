#!/bin/bash

echo "===== Starting postgresql ====="
sudo /etc/init.d/postgresql restart >/dev/null

function stop_all() {
    echo "===== Stopping postgresql ====="
    sudo /etc/init.d/postgresql stop
}

trap stop_all HUP INT QUIT KILL TERM


# wait for postgresql to be available
while true; do
    curl --max-time 2 --fail --silent http://localhost:5432/
    if [[ $? -eq 52 ]]; then
        break
    fi
    sleep 1
done

# initialize the db (pwd: admin) and create users
/home/tracker/bin/roundup-admin -i /opt/tracker/python-dev init admin
python3 /home/tracker/bin/createusers.py

if [ $# -eq 0 ]; then
    /bin/bash
else
    /bin/bash -c "$@"
fi
