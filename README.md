About
------
This repository is a fork of the work done in https://bitbucket.org/introom/docker-b.p.o

This repository serves as a helper for running development instance of
[ruoundup](http://roundup-tracker.org/) tracker living at http://bugs.python.org


Usage
------

1. Pull the docker image or [build](#build) one yourself:

  ```
  sudo docker pull introom/b.p.o
  ```

  In the latter case use appropriate image naming in the following commands.

2. Clone roundup and switch to branch `bugs.python.org`:

  ```
  hg clone https://hg.python.org/tracker/roundup
  hg checkout bugs.python.org
  ```

3. Clone python-dev code:

  ```
  hg clone https://hg.python.org/tracker/python-dev
  ```

4. Setup configuration:

  ```
  cd python-dev
  mkdir db
  echo postgresql > db/backend_name
  cp config.ini.template config.ini
  cp detectors/config.ini.template detectors/config.ini
  ```

5. Run b.p.o container:

  ```
  docker run --rm -it -p 8888:8888 -v $DIR_TRACKER:/opt/tracker introom/b.p.o
  ```

  where `$DIR_TRACKER` is directory where you cloned both roundup and python-dev.
  This will launch the container in interactive mode.

6. Initialize the tracker:

  ```
  rd-admin init
  ```

7. Start the tracker:

  ```
  rd-start
  ```

7. Your local instance of bugs.python.org should be available under http://localhost:8888


Build
------

Building this image locally is as simple as running:

```
make REPO=username
```

where `REPO=username` will be the repository name for your docker images.  If none
is specified `unknown` will be used.


Troubleshooting
------

If you cannot access the b.p.o instance through your browser, chances are you
may be running the docker on a VM, such a boot2docker. Please modify your NAT
settings in that case.

If you have problems with empty `/opt/tracker` directory it means that SELinux
is causing the problem, append `:Z` which will apply appropriate SELinux context:

```
docker run --rm -it -p 8888:8888 -v $DIR_TRACKER:/opt/tracker:Z introom/b.p.o
```
