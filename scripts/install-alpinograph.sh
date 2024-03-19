#!/bin/bash

set -e

cd /build

if [ ! -d alpinograph/.git ]
then
    rm -fr alpinograph/
    git clone --depth=1 https://github.com/rug-compling/alpinograph
fi

git config --global --add safe.directory /build/alpinograph
cd alpinograph
git pull

if [ ! -f ../alpinograph-master ]
then
    touch ../alpinograph-master
fi

if diff -q ../alpinograph-master .git/refs/heads/master
then
    echo geen veranderingen in AlpinoGraph
    exit
fi

make

cd ag
mkdir -p /opt/bin
export CGO_CFLAGS=-I/opt/dbxml6/include
export CGO_CXXFLAGS=-I/opt/dbxml6/include
export CGO_LDFLAGS='-L/opt/dbxml6/lib -Wl,-rpath=/opt/dbxml6/lib'
go build -v -o /opt/bin/alpino2agens .
cd ..

cp .git/refs/heads/master ../alpinograph-master
