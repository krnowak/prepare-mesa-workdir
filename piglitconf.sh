#!/usr/bin/bash

set -e -v -x

cmake -DCMAKE_INSTALL_PREFIX:PATH="${HOME}/oglusr" .
