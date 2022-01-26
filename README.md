About
------
This repository allows you to create a Docker image able to run a development
instance of the [Roundup](http://roundup-tracker.org/) tracker living at
http://bugs.python.org


Usage
-----
1. Pull [python/docker-bpo](https://hub.docker.com/r/python/docker-bpo/) image from
  docker hub:

  ```
  docker pull docker.io/python/docker-bpo
  ```

2. Clone roundup and switch to the `bugs.python.org` branch:

  ```
  git clone git@github.com:psf/bpo-roundup roundup
  cd roundup
  git checkout bugs.python.org
  cd ..
  ```

3. Clone the `python-dev` instance alongside with roundup:

  ```
  git clone git@github.com:psf/bpo-tracker-cpython python-dev
  ```

4. Setup configuration:

  ```
  cd python-dev
  mkdir db
  cp config.ini.template config.ini
  cp detectors/config.ini.template detectors/config.ini
  cd ..
  ```

5. To run the b.p.o container, `cd` in the dir where you cloned both
  `roundup` and `python-dev` and run:

  ```
  docker run --rm -it -p 9999:9999 -v `pwd`:/opt/tracker docker.io/python/docker-bpo
  ```

  This will launch the container in interactive mode, and mount the dir
  with the clones to the container's `/opt/tracker`.

6. Every time the container is run, the tracker is initialized and 3
  users are created.  You can then run the tracker with:

  ```
  rd-start
  ```

7. Your local instance of bugs.python.org should be available at
  http://localhost:9999
  On top of the two default users (`admin` and `anonymous`),
  3 additional users are also available:
  * `user`: a regular user
  * `developer`: a developer (triager) that signed the cla
  * `coordinator`: a coordinator and committer that signed the cla

  You can login as any of these 3 users using `pass` as password.


Notes
-----
* Every time you stop the container, all the users and issues you
  created will be deleted.
* Every time you start the container, the tracker is initialized
  and the 3 users are created.
* Once the container is running, you can start and stop the tracker
  with `rd-start` and `ctrl+c`.
* When you register a new user, look in `python-dev/debugmail.txt`:
  you will find a confirmation URL.  Copy it in your broswer and
  replace all the escaped `=3D` with `=`.
* You can edit the code in `roundup` and `python-dev` from outside
  the container, since those dir are shared.
* If you edit the code, you'll need to restart the tracker.
  Changes to the templates (the `html` dir) do not require a restart.
* See https://wiki.python.org/moin/TrackerDevelopment for more info.


Troubleshooting
---------------
If you cannot access the b.p.o instance through your browser, chances are you
may be running the docker on a VM, such a boot2docker. Please modify your NAT
settings in that case.

If you have problems with empty `/opt/tracker` directory it means that SELinux
is causing the problem, append `:Z` which will apply appropriate SELinux context:

```
docker run --rm -it -p 9999:9999 -v `pwd`:/opt/tracker:Z docker.io/python/docker-bpo
```

On some systems (Fedora, Red Hat, Centos) due to security constraints docker
requires `sudo` to be run, make sure to update above commands appropriately in
that case.


ACKS
----
Thanks to @introom for the initial version of this repo.
