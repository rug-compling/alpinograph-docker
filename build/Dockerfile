# tar vczf go.tar.gz --exclude=.git /go/alpinograph
# tar vczf agensgraph.tar.gz /my/opt/agensgraph
# tar vczf dbxml2.tar.gz /my/opt/dbxml-rug-compling/lib
# tar vczf dbxml6.tar.gz /my/opt/dbxml-6.1.4-patch_26647/lib
# pushd /home/peter/web/urd/www/alpinograph && tar vczf /my/docker/AlpinoGraph/build/alpg.tar.gz --exclude=.git --exclude=docs --exclude=tmp --exclude login --exclude login.home --exclude login.urd2 --exclude=.dc --exclude .vscode . && popd

FROM debian:10

MAINTAINER Peter Kleiweg <p.c.j.kleiweg@rug.nl>

RUN apt-get update && apt-get install -y tzdata && \
    echo "Europe/Amsterdam" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN apt-get install -y \
  apache2 \
  git \
  golang-1.11-go \
  graphviz \
  less \
  libcurl3-gnutls \
  libreadline7 \
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

ADD agensgraph.tar.gz /
ADD dbxml2.tar.gz /
ADD dbxml6.tar.gz /
ADD go.tar.gz /
RUN rm -r /var/www/html/*
ADD libs.tar.gz /usr/lib/x86_64-linux-gnu
ADD alpg.tar.gz /var/www/html
ADD dact_attrib /usr/local/bin
ADD dact_attrib_v6 /usr/local/bin

ADD login /var/www/html/bin

ADD jquery.js /var/www/html

RUN echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ADD root.sh /
ADD user.sh /
ADD env.sh /
ADD help.txt /

EXPOSE 80

RUN cd /var/www/html && \
    echo >> go.mod && \
    echo 'replace github.com/pebbe/dbxml  => /go/alpinograph/src/github.com/pebbe/dbxml' >> go.mod && \
    echo >> go.mod && \
    echo 'replace github.com/pebbe/dbxml2 => /go/alpinograph/src/github.com/pebbe/dbxml2' >> go.mod && \
    PATH=/usr/lib/go-1.11/bin:$PATH make

RUN cd /var/www/html/ag && \
    echo >> go.mod && \
    echo 'replace github.com/pebbe/dbxml  => /go/alpinograph/src/github.com/pebbe/dbxml' >> go.mod && \
    echo >> go.mod && \
    echo 'replace github.com/pebbe/dbxml2 => /go/alpinograph/src/github.com/pebbe/dbxml2' >> go.mod && \
    PATH=/usr/lib/go-1.11/bin:$PATH make

CMD ["/bin/bash", "--rcfile", "/root.sh"]
