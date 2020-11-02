#!/bin/bash
#
# Deploy Lua code to attached NodeMCU
#
basedir=$(cd $(dirname $0)/..; /bin/pwd)
. $basedir/deps/cooplight-venv/bin/activate
nodemcu-uploader upload $basedir/src/*.lua