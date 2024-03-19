#!/bin/bash

set -e

unset CDPATH
script="$(readlink -f "$0")"
cd "$(dirname "$script")"

set -x
docker push registry.webhosting.rug.nl/compling/alpinograph:latest
