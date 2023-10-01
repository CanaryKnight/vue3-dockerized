#!/bin/sh

set -e

rm -rf dist && mkdir -p dist

rm -rf node_modules && CYPRESS_CACHE_FOLDER=/.cache/cypress YARN_CACHE_FOLDER=/.cache/yarn yarn install

#chgrp -R node:node .

yarn run dev