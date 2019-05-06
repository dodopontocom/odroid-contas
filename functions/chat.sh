#!/bin/bash
#
BASEDIR=$(dirname $0)
words=${BASEDIR}/texts/words.txt

chat.hi() {
	echo ${words}
	echo ${txt}
	amount=$(cat ${words} | wc -l)
	r_amount=$(head -c 500 /dev/urandom | tr -dc "1-${amount}" | fold -w 1 | head -n 1)
	message=$(sed -n "${r_amount}p" < ${words})
  	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}
