FROM debian:jessie

# add stretch repositories to obtain the latest taurus 3.6.0
#RUN echo "deb http://ftp.es.debian.org/debian/ stretch main" >> \
#    /etc/apt/sources.list && \
#    echo "deb-src http://ftp.es.debian.org/debian/ stretch main" >> \
#    /etc/apt/sources.list
#RUN echo "deb http://ftp.debian.org/debian/ sid main" >> \
#    /etc/apt/sources.list && \
#    echo "deb-src http://ftp.debian.org/debian/ sid main" >> \
#    /etc/apt/sources.list
RUN apt-get update

# install and configure supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# change installation dialogs policy to noninteractive
# otherwise debconf raises errors: unable to initialize frontend: Dialog
ENV DEBIAN_FRONTEND noninteractive

# change policy for starting services while installing
# otherwise policy-rc.d denies execution of start
# http://askubuntu.com/questions/365911/why-the-services-do-not-start-at-installation
# finally the approach is to not start services when building image
# the database will be fead from file, instead of creating tables
# RUN echo "exit 0" > /usr/sbin/policy-rc.d

# install mysql server
RUN apt-get install -y mysql-server

#install tango-db
RUN apt-get install -y tango-db

# install sardana dependencies
RUN apt-get install -y python ipython ipython-qtconsole python-lxml python-nxs\
                       python-pytango #python-taurus
RUN apt-get install -y python-pip git
RUN pip install git+https://github.com/taurus-org/taurus.git@develop
RUN pip install itango==0.0.1
# configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/

# add macroserver environment with:
# _SAR_DEMO = <sar_demo execution results>
# JsonRecorder = True
# ScanDir = /tmp
# ScanFile = test.h5, test.dat
# ActiveMntGrp = mntgrp01
RUN mkdir -p /tmp/tango/MacroServer/demo1
COPY macroserver.properties /tmp/tango/MacroServer/demo1/

# copy & untar mysql tango database (with sardemo) and change owner to mysql user
ADD tangodbsardemo.tar /var/lib/mysql/
RUN chown -R mysql /var/lib/mysql/tango

ENV TANGO_HOST=sardana-test:10000
# start supervisor as deamon
CMD /usr/bin/supervisord
