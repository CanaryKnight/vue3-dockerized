#!/usr/bin/env bash

_start_step() { _STEP_MSG=$1; export _STEP_MSG; echo -en " ⬜ $(tput setaf 3)$1$(tput sgr0) ...";}

_end_step() { echo -e echo -e "\r\e[K ✅ $(tput setaf 2)${_STEP_MSG}$(tput sgr0)";}

