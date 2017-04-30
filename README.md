# Code Compass dev docker image

## Getting started

### Using docker-compose

First of all you have to install docker and docker-compose
from [dockers page][docker download page]

You can use this image with the [original Code Compass repo][codecompass origin] and
have [my compose sample][my compose file] file to get started.

1. checkout the [project][codecompass origin]
2. put the [docker-compose.yaml][my compose file] to the projects root. This file assumes the project root
    is `~/Projects/CodeCompass` on your machine. Change it if your differs. The build and codecompass services havve a
    common shared folder named ~/cc. This folder will contain the built version of Code Compass (built by the build service).
    Change the pass if you want to change its location on your machine.
3. start the images with `docker-compose up -d` from the project root
4. make your modifications on the Code Compass project and start the build container with `docker-compose start build`
then restart the codecompass container with `docker-compose restart codecompass`

*Note:* Do not change the paths after the colon (`:`) unless you know what are you doing.

### Using the web db interface

1. with `docker-compose up -d` the db_admin image started automatically and available on on http://localhost:8081
2. login with custom options. Use pgsql, the default user and password is "pgsql". The host is 'db'
(this is the hostname of the db container. Docker handles the host).

## Some useful tips

### Checking logs of the container

1. step into the project root
2. `docker-compose logs codecompass` shows the logs of the codecompass service container.

Alternatively you can use [Kitematic][kitematic] to check the logs and settings of conainers.

For further information check [docker][docker docs] and [docker-compose docs][compose docs].

If you have any troubles or have ideas feel free to open an issue.

### Connect to a running container

1. step into the project root
2. connect a bash terminal to a running container (lets say to the codecompass service container)
`docker-compose exec -i -t codecompass /bin/bash`

### Experimentinf with build or codecompass images

Just set copy codecompass or build service (or modify the original) with changing the
command argument to `["/bin/bash"]` then run the following (assuming your new service name is 'experiment'):
``` bash
$ docker-compose rm 'experiment' # if experiment container already exists and stoped
$ docker-compose create 'experiment'
$ docker-compose start 'experiment'
```

[docker download page]: https://www.docker.com/
[codecompass origin]: https://github.com/Ericsson/CodeCompass/
[my compose file]: https://github.com/rockkid777/CodeCompass/blob/dockerizing/docker-compose.yaml.sample
[kitematic]: https://docs.docker.com/kitematic/
[docker docs]: https://docs.docker.com/
[compose docs]: https://docs.docker.com/compose/
