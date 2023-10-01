#!/usr/bin/env bash

set -e

source ./.docker/.env

C_UID=$(id -u)
C_GID=$(id -g)
CURRENT_DIR=$PWD

if  [ -d "$CURRENT_DIR/app" ]; then
  echo ""
  echo "Directory $(tput setaf 2)./app$(tput sgr0) already exists!"
  echo "Run $(tput setaf 1)rm -rf ./app && make create_app$(tput sgr0) to recreate."
  echo ""
  exit 1
fi;

mkdir app && cd "$_" && docker run --rm -v "${PWD}:/$(basename `pwd`)" -w "/$(basename `pwd`)" -it node:"$NODE_IMAGE_VERSION" sh -c " yarn create vue . && yarn install && chown -R $C_UID:$C_GID ."

if  [ -d "$CURRENT_DIR/app/.vscode" ]; then
  rm -rf "$CURRENT_DIR"/.vscode/
  mkdir -p "$CURRENT_DIR"/.vscode/
  mv -f "$CURRENT_DIR"/app/.vscode "$CURRENT_DIR"/
fi;

mv -f "$CURRENT_DIR"/app/.gitignore "$CURRENT_DIR"/.gitignore

sed  -i 's/export default defineConfig({/export default defineConfig({\n  server: {\n    host: true,\n    port: 8080,\n    watch: {\n      usePolling: true,\n    }\n  },/' "$CURRENT_DIR"/app/vite.config.ts