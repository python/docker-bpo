#!/bin/bash

echo "* Starting postgresql..."
sudo /etc/init.d/postgresql restart >/dev/null

function stop_all() {
    echo "* Stopping postgresql..."
    sudo /etc/init.d/postgresql stop
}

trap stop_all HUP INT QUIT KILL TERM



# initialize the db (pwd: admin) and create users
echo "* Initializing Roundup..."
/home/tracker/bin/roundup-admin -i /opt/tracker/python-dev init admin
python3 /home/tracker/bin/createusers.py

if [ $# -eq 0 ]; then
    /bin/bash
else
    /bin/bash -c "$@"
fi
