About
------
This repository allows you to create a Docker image able to run a development
instance of the [Roundup](http://roundup-tracker.org/) tracker living at
http://bugs.python.org


Usage
-----
1. Clone the repo and build the image using:

  ```
  make USERNAME=username
  ```

  where `username` will be the repository name for your Docker image
  (default: `unknown`).  You can also use e.g. `BASE_DISTRO=fedora` 
  to specify the base distribution (default: `ubuntu`).

  Note: in the future this image will be moved do DockerHub.

2. Clone roundup and switch to the `bugs.python.org` branch:

  ```
  hg clone https://hg.python.org/tracker/roundup
  cd roundup
  hg update bugs.python.org
  ```

3. Clone the `python-dev` instance alongside with roundup:

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

5. To run the b.p.o container, `cd` in the dir where you cloned both
  `roundup` and `python-dev` and run:

  ```
  docker run --rm -it -p 9999:9999 -v `pwd`:/opt/tracker username/b.p.o
  ```

  (replace `username` with the value used during `make`).
  This will launch the container in interactive mode, and mount the dir
  with the clones to the container's `/opt/tracker`.

6. Create a new empty instance of `python-dev` using:

  ```
  rd-admin init
  ```

7. Run it using:

  ```
  rd-start
  ```

8. Your local instance of bugs.python.org should be available under
  http://localhost:9999


Notes
-----
* Every time you stop the container, all the users and issues you 
  created will be deleted
* Every time you start the container, you will need to run 
  `rd-admin init` again and reinitialize the tracker
* Once the container is running, you can start and stop the tracker
  with `rd-start` and `ctrl+c`
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
docker run --rm -it -p 9999:9999 -v $DIR_TRACKER:/opt/tracker:Z introom/b.p.o
```

On some systems (Fedora, Red Hat, Centos) due to security constraints docker
requires `sudo` to be run, make sure to update above commands appropriately in
that case.


ACKS
----
Thanks to @introom for the initial version of this repo.
