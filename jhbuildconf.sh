#!/usr/bin/bash

set -e -v -x

d="$(dirname $0)"
b="${d}/build"

mkdir -p "${b}"

cd "${b}"

../src/configure --prefix="${HOME}/oglusr"
