#!/bin/bash


#### BEGIN VAN OPTIES ###

# portnummer voor je browser: http://localhost:$port/
port=8234

# waar alle data wordt opgeslagen
# (het path naar) deze directory moet leesbaar zijn voor docker (voor iedereen?)
data=$HOME/.var/AlpinoGraph

#### EINDE VAN OPTIES ####

image=registry.webhosting.rug.nl/compling/alpinograph:latest

case "$1" in
    run)
        ;;
    upgrade)
	docker pull $image
	exit
	;;
    *)
	echo
	echo "Gebruik:"
	echo
	echo "    $0 run"
	echo "    $0 upgrade"
	echo
	exit
esac


if [ ! -d "$data" ]
then
    mkdir -p "$data"
fi

if [ ! -d "$data" ]
then
    echo Directory $data kon niet gemaakt worden
    exit
fi

# xdg-open http://localhost:$port/ &> /dev/null &
echo
echo AlpinoGraph wordt gestart op http://localhost:$port/
echo

docker run \
   --rm \
   -i -t \
   -h alpinograph.`hostname -d` \
   -e USER=`id -u` \
   -e GROUP=`id -g` \
   -p $port:80 \
   -v $data:/home/user \
   $image
