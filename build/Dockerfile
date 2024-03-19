#
# Debian 12 (bookworm) met gcc en zo
#

FROM debian:bookworm

MAINTAINER Peter Kleiweg <p.c.j.kleiweg@rug.nl>

RUN apt-get update && apt-get install -y tzdata && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y \
  bison \
  build-essential \
  flex \
  git \
  golang-1.19-go \
  less \
  libreadline-dev \
  libxml2-utils \
  locales \
  make \
  mc \
  nano \
  wget \
  zlib1g-dev

RUN localedef -i nl_NL -c -f UTF-8 -A /usr/share/locale/locale.alias nl_NL.UTF-8

ENV GOCACHE /cache/go/cache
ENV GOPATH /cache/go
ENV PATH /opt/bin:/opt/agensgraph/bin:/usr/lib/go-1.19/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ADD init.sh /

CMD ["/bin/bash", "--rcfile", "/init.sh"]
