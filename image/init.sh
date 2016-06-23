#!/bin/sh

trap stop_all HUP INT QUIT KILL TERM

# start postgres
su - postgres -c "/usr/libexec/postgresql-ctl start -D ${PGDATA} -s -w -t ${PGSTARTTIMEOUT}"

stop_all() {
  echo stopping!
  su - postgres -c "/usr/libexec/postgresql-ctl stop -D ${PGDATA} -s -m fast"
}

if [ $# -eq 0 ]; then
  /bin/bash
else
  /bin/bash -c "$@"
fi
