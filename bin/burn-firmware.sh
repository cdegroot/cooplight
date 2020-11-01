#!/bin/bash
basedir=$(cd $(dirname $0)/..; /bin/pwd)
. $basedir/deps/cooplight-venv/bin/activate

cd $basedir/deps/nodemcu-firmware/bin
esptool.py write_flash -fm qio 0x00000 0x00000.bin
esptool.py write_flash -fm qio 0x10000 0x10000.bin