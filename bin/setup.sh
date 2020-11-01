#!/bin/sh

asdf install

setup_python() {
  virtualenv deps/cooplight-venv
}

test -d deps/cooplight-venv || setup_python
pip install --upgrade pip
. deps/cooplight-venv/bin/activate
pip install -r requirements.txt
asdf reshim python

which lunit || luarocks install lunit
asdf reshim lua