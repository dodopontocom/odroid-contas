#!/bin/bash

# initialize variables
BASEDIR=$(dirname $0)
verbose=0
dryrun=0
num_str=
time_str=

OPTS=$(getopt -o "hn:t:v" --long "help,num:,time:,verbose,dry-run" -n "$(basename $0)" -- "$@")
if [[ $? != 0 ]]; then
  echo "Error in command line arguments." >&2
  exit 1
fi

eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help )
      helper.usage
      exit
      ;;
    
    -n | --num )
      num_str="$2"
      echo "num: $2"
      shift 2
      ;;

    -t | --time )
      time_str="$2"
      echo "time: $2"
      shift 2
      ;;

    --dry-run )
      dryrun=1
      shift
      ;;
    -v | --verbose )
      verbose=$((verbose + 1))
      shift
      ;;

    -- )
      shift
      break
      ;;

    * )
      break
      ;;

  esac
done