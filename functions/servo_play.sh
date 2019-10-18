#!/bin/bash
#
# Play with servo python script
# Dependency of python3
# usage: script.py <time 'float' to wait then return to original state>
#                    <time 'float' to wait and make a turn on the initial part>
#                    <time 'float' to wait and make a turn on the final part>

servo.test () {
  local message

  python3 ${BASEDIR}/functions/servo_motor.py "1" "0.003" "0.003"
  if [[ $? -eq 0 ]]; then
    message="command success!"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}

servo.with_args () {
  local message arg1 arg2 arg3

  arg1=$1
  arg2=$2
  arg3=$3

  python3 ${BASEDIR}/functions/servo_motor.py "${arg1}" "${arg2}" "${arg3}"
  if [[ $? -eq 0 ]]; then
    message="command success!"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}

servo.play () {
  local cmd array message

  cmd=$1
  array=(${cmd})
  array[0]="/servo"
  cmd=${array[@]:1}
  
  if [[ -z ${cmd[@]} ]]; then
    servo.test
  else
    shift
    servo.with_args ${cmd[@]}
  fi
}