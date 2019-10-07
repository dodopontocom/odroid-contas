#!/bin/bash

sed_file=${BASEDIR}/configurations/remove_acentos.sed

remove.acento() {
  local str ret_str
  
  str=$1
  ret_str=$(echo "$str" | sed -f $sed_file)
  echo $ret_str
}
