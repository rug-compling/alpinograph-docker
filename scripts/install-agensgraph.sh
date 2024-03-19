#!/bin/bash

set -e

cd /agensgraph

if [ -f OK ]
then
    echo AgensGraph already installed
    exit
fi

./configure --prefix=/opt/agensgraph
make
make install
make distclean

touch OK
