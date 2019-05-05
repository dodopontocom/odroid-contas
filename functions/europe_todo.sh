#!/bin/bash
#
BASEDIR=$(dirname $0)
txt=${BASEDIR}/texts/europe_todo.txt
groupId=-263066376

europe_todo.message() {
  amount=$(cat ${txt} | wc -l)
  r_amount=$(head -c 500 /dev/urandom | tr -dc "1-${amount}" | fold -w 1 | head -n 1)
  message=$(sed -n "${r_amount}p" < ${txt})
  if [[ $(echo ${message} | grep -E "\|") ]]; then
  	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message} | cut -d'|' -f1)" --parse_mode markdown
  	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message} | cut -d'|' -f2)" --parse_mode markdown
  else
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}
europe_todo_random.message() {
  amount=$(cat ${txt} | wc -l)
  r_amount=$(head -c 500 /dev/urandom | tr -dc "1-${amount}" | fold -w 1 | head -n 1)
  message=$(sed -n "${r_amount}p" < ${txt})
  if [[ $(echo ${message} | grep -E "\|") ]]; then
  	ShellBot.sendMessage --chat_id ${groupId} --text "$(echo -e ${message} | cut -d'|' -f1)" --parse_mode markdown
  	ShellBot.sendMessage --chat_id ${groupId} --text "$(echo -e ${message} | cut -d'|' -f2)" --parse_mode markdown
  else
	ShellBot.sendMessage --chat_id ${groupId} --text "$(echo -e ${message})" --parse_mode markdown
  fi
}
