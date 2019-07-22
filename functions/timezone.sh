#!/bin/bash
#
#❌
#✅
#✖

timezone.place() {
	local array apiUrl place message country
	place=$1
	array=(${place})
  	array[0]="/timezone"
  	place=${array[@]:1}
	
	multi_word_city_capital=$(for i in ${place}; do B=`echo -n "${i:0:1}" | tr "[:lower:]" "[:upper:]"`; echo -n "${B}${i:1} "; done | sed 's/Of/of/g')
	var=($(echo ${multi_word_city_capital}))
	multi_word_city=$(final=""; for i in ${var[@]}; do final+=${i}_; done; echo ${final})
	capital=$(echo ${multi_word_city::-1})

	region=$(curl -s http://worldtimeapi.org/api/timezone | grep -Eo "[A-Z][a-z]*\/${capital}" | cut -d'/' -f1)
	apiUrl="http://worldtimeapi.org/api/timezone/${region}/${capital}.txt"
	
	message="${place^} ✅ "
	message+="\`$(curl -s ${apiUrl} | grep ^datetime | cut -d'T' -f2 | cut -d'.' -f1)\`"

	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}



