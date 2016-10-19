#!/bin/sh

set -e
set -x


compliance-masonry get
compliance-masonry docs gitbook FedRAMP-moderate
cd exports

# return to top-level directory
trap "cd .." SIGINT

gitbook serve
