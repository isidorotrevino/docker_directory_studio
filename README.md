# Eclipse ~ Grails 3 - Docker Container



Eclipse Mars.2 in a Docker container with required plugins for Grails 3 development

* It is based on the work by fghrem, pay him a visit in his [docker-eclipse](https://github.com/fgrehm/docker-eclipse/) repository.
* I built it based on some suggestions from Ted Vinke's [Java Code Geeks article](https://www.javacodegeeks.com/2015/10/eclipse-mars-grails-3-1-with-gradle-groovy-and-gsp-support.html)

In a nutshell has the following plugins installed:

* Spring IDE (for YML and Spring boot support)
* Grails IDE (for GSP editing and quicksearch)
* Gradle support
* Docker support (if you're running the IDE from a docker container, why not run other containers from it?)

The following instructions work were copied from fghrem's repository, as they work in the same way

## Requirements

* Docker 1.2+ (the image was built and tested in Docker 1.10.3 )
* An X11 socket

## Quickstart

Assuming `$HOME/bin` is on your `PATH` and that you are able to run `docker`
commands [without `sudo`](http://docs.docker.io/installation/ubuntulinux/#giving-non-root-access),
you can use the [provided `eclipse` script](eclipse) to start a disposable
Eclipse Docker container with your project sources mounted at `/home/developer/workspace`
within the container:

```sh
# The image size is currently 1.292 GB, so go grab a coffee while Docker downloads it
docker pull vintec/eclipse_grails3:mars
L=$HOME/bin/eclipse && curl -sL https://github.com/vintecdynamics/eclipse_grails3/raw/master/eclipse > $L && chmod +x $L
cd /path/to/java/project
eclipse
```

Once you close Eclipse the container will be removed and no traces of it will be
kept on your machine (apart from the Docker image of course).

## Making plugins persist between sessions

Eclipse plugins are kept on `$HOME/.eclipse` inside the container, so if you
want to keep them around after you close it, you'll need to share it with your
host.

For example:

```sh
mkdir -p .eclipse-docker
docker run -ti \
           --name eclipse_grails3 \
           -e DISPLAY=$DISPLAY \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v `pwd`:/home/developer/workspace \
           -v `echo $HOME`/.gradle:/home/developer/.gradle \
           vintec/eclipse_grails3:mars
```

## Help! I started the container but I don't see the Eclipse screen

You might have an issue with the X11 socket permissions since the default user
used by the base image has an user and group ids set to `1000`, in that case
you can run either create your own base image with the appropriate ids or run
`xhost +` on your machine and try again.

