
.PHONY: dev test firmware setup

dev:
	find src test | entr -d make test

test:
	export LUA_PATH="`lua -e 'print(package.path)'`;`pwd`/src/?.lua" ; \
	  for f in test/*_test.lua; do lunit $$f; done

firmware: setup
	bin/build-firmware.sh

setup:
	bin/setup.sh
