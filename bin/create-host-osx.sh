#!/bin/bash

cd `dirname $0`/..
mkdir hosts

cd util
pito host-osx-app -o ../hosts/osx/ $@
