#!/bin/bash

#### BEGIN VAN OPTIES ###

# portnummer voor je browser: http://localhost:$port/
port=8079

# waar alle data wordt opgeslagen
data=/my/docker/AlpinoGraph-data

#### EINDE VAN OPTIES ####


if [ ! -d "$data" ]
then
    mkdir -p "$data"
fi

if [ ! -d "$data" ]
then
    echo Directory $data kon niet gemaakt worden
fi

echo -n -e '\033]0;docker:AlpinoGraph\007'
docker run \
   --rm \
   -i -t \
   -e USER=`id -u` \
   -e GROUP=`id -g` \
   -p $port:80 \
   -v $data:/home/user \
   rugcompling/alpinograph:latest
