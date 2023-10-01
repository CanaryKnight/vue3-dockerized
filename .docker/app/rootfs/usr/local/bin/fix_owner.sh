#!/usr/bin/env bash

if [ $GROUP_ID -eq "1000" ]; then
  exit 0
fi;


if [ ! $(getent group "$GROUP_ID") ]; then
  addgroup -g "$GROUP_ID" -S canary

fi;

adduser node "$GROUP_ID"