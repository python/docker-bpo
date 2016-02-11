#!/bin/sh

trap stop_all HUP INT QUIT KILL TERM

# start postgres
sudo /etc/init.d/postgresql start >/dev/null

stop_all() {
  echo stopping!
  sudo /etc/init.d/postgresql stop
}

if [ $# -eq 0 ]; then
  /bin/bash
else
  /bin/bash -c "$@"
fi
