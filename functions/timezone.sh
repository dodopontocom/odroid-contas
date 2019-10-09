#!/bin/bash
#
#❌
#✅
#✖

# Função com bug
# Função desabilitada

timezone.place() {
	local array apiUrl place message country
	
	message+="Comando em manutenção 😔"
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}
disabled() {
	place=$1
	array=(${place})
  	array[0]="/timezone"
  	place=${array[@]:1}
	
	multi_word_city_capital=$(for i in ${place}; do B=`echo -n "${i:0:1}" | tr "[:lower:]" "[:upper:]"`; echo -n "${B}${i:1} "; done | sed 's/Of/of/g')
	var=($(echo ${multi_word_city_capital}))
	multi_word_city=$(final=""; for i in ${var[@]}; do final+=${i}_; done; echo ${final})
	capital=$(echo ${multi_word_city::-1})

	region=$(curl -s ${TIMEZONE_API_URL} | grep -Eo "[A-Z][a-z]*\/${capital}" | cut -d'/' -f1)
	apiUrl="${TIMEZONE_API_URL}/${region}/${capital}.txt"
	
	message="${region} - ${place^} ✅ "
	message+="\`$(curl -s ${apiUrl} | grep ^datetime | cut -d'T' -f2 | cut -d'.' -f1)\`"

	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}


