FROM ubuntu:14.04
MAINTAINER Isidoro Trevino "chololo@gmail.com"

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list && \
    apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer libxext-dev libxrender-dev libxtst-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN apt-get update && apt-get install -y libgtk2.0-0 libcanberra-gtk-module

RUN wget http://www-eu.apache.org/dist/directory/studio/2.0.0.v20151221-M10/ApacheDirectoryStudio-2.0.0.v20151221-M10-linux.gtk.x86_64.tar.gz -O /tmp/eclipse.tar.gz -q && \
    echo 'Installing Apache Directory Studio' && \
    tar -xf /tmp/eclipse.tar.gz -C /opt && \
    rm /tmp/eclipse.tar.gz

ADD run /usr/local/bin/eclipse

RUN chmod +x /usr/local/bin/eclipse && \
    mkdir -p /home/developer && \
    mkdir -p /home/developer/.m2 && \
    mkdir -p /home/developer/.gradle && \
    mkdir -p /projects && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer && \
    chown developer:developer -R /projects && \
    chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo && \
    ls -la /tmp && \
    rm -rf /tmp/*

VOLUME [ "/home/developer/.m2","/home/developer/.gradle","/projects" ]
USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD /usr/local/bin/eclipse

