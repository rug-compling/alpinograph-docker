FROM debian:bookworm

MAINTAINER Peter Kleiweg <p.c.j.kleiweg@rug.nl>

RUN apt-get update && apt-get install -y tzdata && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y \
  apache2 \
  git \
  golang-1.19-go \
  graphviz \
  less \
  libcurl3-gnutls \
  libreadline8 \
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

ADD opt /opt

RUN rm -r /var/www/html/*
ADD alpinograph /var/www/html
RUN rm -r /var/www/html/.git

ADD login /var/www/html/bin

ADD jquery.js /var/www/html

ADD env.sh root.sh user.sh help.txt /

RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 80

RUN groupadd --system --gid 999 agensgraph; \
    useradd --system --uid 999 --gid 999 --home-dir /opt/agensgraph --no-create-home agensgraph

ENV PATH /opt/bin:/opt/agensgraph/bin:/usr/lib/go-1.19/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

CMD ["/bin/bash", "--rcfile", "/root.sh"]
