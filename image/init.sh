#!/bin/sh
if which apt-get > /dev/null; then \
  # start postgres
  sudo /etc/init.d/postgresql start >/dev/null

  stop_all() {
    echo stopping!
    sudo /etc/init.d/postgresql stop
  }
elif which dnf > /dev/null; then \
  # start postgres
  su - postgres -c "/usr/libexec/postgresql-ctl start -D ${PGDATA} -s -w -t ${PGSTARTTIMEOUT}"

  stop_all() {
    echo stopping!
    su - postgres -c "/usr/libexec/postgresql-ctl stop -D ${PGDATA} -s -m fast"
  }
fi

trap stop_all HUP INT QUIT KILL TERM

if [ $# -eq 0 ]; then
  /bin/bash
else
  /bin/bash -c "$@"
fi
