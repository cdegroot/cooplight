#!/bin/sh

setup_python() {
  virtualenv deps/cooplight-venv
  . deps/cooplight-venv/bin/activate
  pip install --upgrade pip
  pip install -r requirements.txt
}

test -d deps/cooplight-venv || setup_python

luarocks install lunit
asdf reshim lua