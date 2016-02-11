FROM ubuntu:14.04

RUN apt-get update && apt-get install -y language-pack-en -y \
    && update-locale LANG=en_US.UTF-8 LC_MESSAGES=POSIX \
    && apt-get install -y postgresql postgresql-contrib

# for ease of development, give privilege to every local user
RUN sed -i '/^#/!{s/peer/trust/;s/md5/trust/;}' /etc/postgresql/9.3/main/pg_hba.conf

RUN /etc/init.d/postgresql start && \
    psql -U postgres \
      --command "CREATE USER roundup; ALTER USER roundup WITH CREATEDB"

# allow backup of config, logs and databases
# maybe we don't need this
# VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]


# TRACKER SPECIFIC

# for interactive use
ENV PYTHONUNBUFFERED 1

VOLUME ["/opt/tracker/"]

# python-dev, libffi-dev, libssl-dev are required by pyoic
RUN apt-get install -y python python-psycopg2 python-pip python-dev libffi-dev libssl-dev

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
RUN echo "alias rd-start=\"/home/tracker/bin/roundup-server -n 0.0.0.0 -p 8888 python-dev=/opt/tracker/python-dev\"" >> ~/.bashrc
RUN echo "alias rd-admin=\"/home/tracker/bin/roundup-admin -i /opt/tracker/python-dev\"" >> ~/.bashrc

EXPOSE 8888
