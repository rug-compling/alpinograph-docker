#!/bin/bash

set -e

cd /src

if [ ! -f /opt/bin/dact_attrib -o /opt/bin/dact_attrib -ot dact_attrib.go ]
then
    export CGO_CFLAGS=-I/opt/dbxml2/include
    export CGO_CXXFLAGS=-I/opt/dbxml2/include
    export CGO_LDFLAGS='-L/opt/dbxml2/lib -Wl,-rpath=/opt/dbxml2/lib'
    go build -v -o /opt/bin/dact_attrib .
else
    echo dact_attrib is up-to-date
fi

if [ ! -f /opt/bin/dact_attribi_v6 -o /opt/bin/dact_attrib_v6 -ot dact_attrib.go ]
then
    export CGO_CFLAGS=-I/opt/dbxml6/include
    export CGO_CXXFLAGS=-I/opt/dbxml6/include
    export CGO_LDFLAGS='-L/opt/dbxml6/lib -Wl,-rpath=/opt/dbxml6/lib'
    go build -v -o /opt/bin/dact_attrib_v6 .
else
    echo dact_attrib_v6 is up-to-date
fi
