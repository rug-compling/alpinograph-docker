# tar vczf go.tar.gz --exclude=.git /go/alpinograph
# tar vczf agensgraph.tar.gz /my/opt/agensgraph-new
# tar vczf dbxml.tar.gz /my/opt/dbxml-6.1.4-patch_26647/lib
# pushd /home/peter/web/urd/www/alpinograph && tar vczf /my/docker/AlpinoGraph/build/alpg.tar.gz --exclude=.git --exclude=docs --exclude=tmp . && popd

FROM debian:10

MAINTAINER Peter Kleiweg <p.c.j.kleiweg@rug.nl>

RUN apt-get update && apt-get install -y tzdata && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y \
  apache2 \
  golang-1.11-go \
  graphviz \
  less \
  libxml2-utils \
  locales \
  make \
  mc \
  nano \
  sudo \
  wget

RUN localedef -i nl_NL -c -f UTF-8 -A /usr/share/locale/locale.alias nl_NL.UTF-8

ADD apache2.txt /
RUN a2enmod cgi && \
    cat /apache2.txt >> /etc/apache2/sites-available/000-default.conf && \
    rm /apache2.txt

RUN apt-get install -y \
  libreadline7 \
  libcurl3-gnutls

ADD agensgraph.tar.gz /
ADD dbxml.tar.gz /
ADD go.tar.gz /
RUN rm -r /var/www/html/*
ADD alpg.tar.gz /var/www/html
ADD libs.tar.gz /usr/lib/x86_64-linux-gnu

ADD favicon.ico /var/www/html
ADD jquery.js /var/www/html

RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD root.sh /
ADD user.sh /
ADD env.sh /

CMD ["/bin/bash", "--rcfile", "/root.sh"]