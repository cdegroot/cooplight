
.PHONY: dev test firmware setup burn erase esplore

dev:
	find src test | entr -d make test

test:
	export LUA_PATH="`lua -e 'print(package.path)'`;`pwd`/src/?.lua" ; \
	  for f in test/*_test.lua; do lunit $$f; done

firmware: setup
	bin/build-firmware.sh

setup:
	bin/setup.sh

burn:
	bin/burn-firmware.sh

esplore:
	nohup java -jar /opt/ESPlorer/ESPlorer.jar >/tmp/esplorer.log 2>&1 &
