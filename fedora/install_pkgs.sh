#!/usr/bin/bash

# -e -> fail on first error
# -v -> print not expanded commands
# -x -> print expanded commands
set -e -v -x

dir="$(dirname $0)"

sudo dnf install $(cat "${dir}/packages")
