#!/bin/bash

error(){
    echo "[ERROR]: $1"
    exit 1
}

starship_version(){
  starship_program_file="$1"
  # Check if this is a relative path: if so, prepend './' to it
  if [ "$1" = "${1#/}" ]; then
    starship_program_file="./$starship_program_file"
  fi
  "$starship_program_file" -V | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+'
}