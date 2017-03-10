FROM debian:9

# fetch latest updates and install postgresql
RUN apt-get update && \
    apt-get install -y sudo postgresql postgresql-contrib && \
    apt-get clean

# for ease of development, give privilege to every local user
RUN sed -i '/^#/!{s/peer/trust/;s/md5/trust/;}' /etc/postgresql/9.6/main/pg_hba.conf && \
    # setup postgresql
    /etc/init.d/postgresql start && \
    psql -U postgres --command "CREATE USER roundup; ALTER USER roundup WITH CREATEDB"


# TRACKER SPECIFIC

# for interactive use
ENV PYTHONUNBUFFERED=1

# directory where tracker sources will be mounted
VOLUME ["/opt/tracker/"]

# install python-dev, libffi-dev, libssl-dev are required by pyoic
RUN apt-get install -y python python-psycopg2 python-pip python-dev libffi-dev libssl-dev curl && \
    apt-get clean

ADD requirements.txt init.sh /

RUN pip install --upgrade pip && \
    pip install -r /requirements.txt && \
    # we delete the http packages introduced by pyoic. it will fail roundup
    rm -rf /usr/local/lib/python2.7/dist-packages/http && \
    chmod +x /init.sh && \
    # roundup doesn't allow running as root
    useradd -ms /bin/bash tracker && \
    echo "tracker ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers

ENTRYPOINT ["/init.sh"]
EXPOSE 9999

USER tracker

# some handy scripts to help the roundup management
ADD bin /home/tracker/bin

# shell settings
RUN echo "alias rd-start=\"/home/tracker/bin/roundup-server -n 0.0.0.0 -p 9999 python-dev=/opt/tracker/python-dev\"" >> ~/.bashrc && \
    echo "alias rd-admin=\"/home/tracker/bin/roundup-admin -i /opt/tracker/python-dev\"" >> ~/.bashrc
