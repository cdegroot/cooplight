#!/bin/bash
#
#  Build NodeMCU firmware
#

basedir=$(cd $(dirname $0)/..; /bin/pwd)

patch=$basedir/bin/user_modules.h.patch

cd $basedir/deps/nodemcu-firmware
git diff --quiet --exit-code app/include/user_modules.h && patch -p1 <$patch

. $basedir/deps/cooplight-venv/bin/activate
make