#!/usr/bin/env bash

set -e

CURRENT_DIR=$PWD

check_command() {
  COMMAND=$1
  if ! command -v "$COMMAND" &> /dev/null
  then
      echo "$(tput setaf 1)$COMMAND could not be found$(tput sgr0)"
      exit 1
  fi;
}

# Check requirements
check_command "git"
check_command "make"
check_command "docker"

if [ -z "$1" ]; then
  echo "$(tput setaf 2)Project name?$(tput sgr0)"

  read PROJECT_NAME
else
  PROJECT_NAME=$1

  echo "$(tput setaf 2)Creating project '$PROJECT_NAME'$(tput sgr0)"
fi;

if [ -d "$CURRENT_DIR"/"$PROJECT_NAME" ]; then
  echo "$(tput setaf 1)Directory '$PROJECT_NAME' already exists$(tput sgr0)";
  exit 1;
fi;

echo ""

git clone https://github.com/CanaryKnight/vue3-dockerized.git "$PROJECT_NAME" &> /dev/null

cd "$PROJECT_NAME" && rm -rf .git && rm -rf "./installer.sh"

make create_app

echo "# $PROJECT_NAME\n\nToDo: Update readme" > "$CURRENT_DIR/$PROJECT_NAME/README.md"


echo ""
echo "$(tput setaf 7)Project '$PROJECT_NAME' created, now run$(tput sgr0)"
echo "$(tput setaf 2)cd $CURRENT_DIR/$PROJECT_NAME && make dev$(tput sgr0)"
echo ""
