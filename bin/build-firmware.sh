#!/bin/bash
#
#  Build NodeMCU firmware
#

basedir=$(cd $(dirname $0)/..; /bin/pwd)


cd $basedir/deps/nodemcu-firmware
git diff --quiet --exit-code app/include/user_modules.h && patch -p1 <$basedir/bin/user_modules.h.patch
git diff --quiet --exit-code app/lua53/luaconf.h && patch -p1 <$basedir/bin/luaconf.h.patch

. $basedir/deps/cooplight-venv/bin/activate

export LUA=53

make