FROM fedora:24

RUN dnf -yv clean all && dnf -yv update

RUN dnf -yv install postgresql postgresql-server postgresql-contrib postgresql-libs postgresql-devel

ENV PGDATA /var/lib/pgsql/data

ENV PGSTARTTIMEOUT 270

RUN su - postgres -c "initdb ${PGDATA}; /usr/libexec/postgresql-check-db-dir %N; /usr/libexec/postgresql-ctl start -D ${PGDATA} -s -w -t ${PGSTARTTIMEOUT}" && \
    psql -U postgres --command "CREATE USER roundup; ALTER USER roundup WITH CREATEDB"

RUN sed -i '/^#/!{s/peer/trust/;s/md5/trust/;}' /var/lib/pgsql/data/pg_hba.conf

# TRACKER SPECIFIC

# for interactive use
ENV PYTHONUNBUFFERED 1

VOLUME ["/opt/tracker/"]

# python-dev, libffi-dev, libssl-dev are required by pyoic
RUN dnf -yv install python python-psycopg2 python-pip python-devel libffi-devel openssl-devel gcc-c++ redhat-rpm-config

ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
# we delete the http packages introduced by pyoic. it will fail roundup
RUN rm -rf /usr/local/lib/python2.7/dist-packages/http

ADD init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]

# roundup doesn't allow running as root
RUN useradd -ms /bin/bash tracker
RUN echo "tracker ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

USER tracker

# some handy scripts to help the roundup management
ADD bin /home/tracker/bin

# shell settings
RUN echo "alias rd-start=\"/home/tracker/bin/roundup-server -n 0.0.0.0 -p 9999 python-dev=/opt/tracker/python-dev\"" >> ~/.bashrc
RUN echo "alias rd-admin=\"/home/tracker/bin/roundup-admin -i /opt/tracker/python-dev\"" >> ~/.bashrc

EXPOSE 9999
