#!/bin/bash
#
#❌
#✅
#✖

_message="Listando..."
# Função Pessoal para nossa viagem a europa
trip.checklist() {
	local opt array
	opt=$1
  	array=(${opt})
  	array[0]="/trip"
  	opt=${array[@]:1}

    case ${opt} in
	    'list')
      	    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Checklist da Nossa Viagem:" --reply_markup "$keyboard_trip_checklist"
			;;
		'edit')
      	    list.edit
			#ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Checklist da Nossa Viagem:" --reply_markup "$keyboard_trip_checklist"
			;;
		'')
	     	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "Checklist da Nossa Viagem:" --reply_markup "$keyboard_trip_checklist"
            ;;
  	esac
}

list.edit() {
	echo "to do function"
}

list.all() {
	while read line; do
		ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "$(echo -e ${_message})"
 	 	ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $line)" --parse_mode markdown
	done < ${TRIP_CHECKLIST_FILE}
}
list.pending() {
	while read line; do
		if [[ $(echo $line | grep -E '❌') ]]; then
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "$(echo -e ${_message})"
	  		ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e ${line})" --parse_mode markdown
		fi
	done < ${TRIP_CHECKLIST_FILE}
}
list.done() {
	while read line; do
		if [[ $(echo $line | grep -E '✅') ]]; then
			ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "$(echo -e ${_message})"
	  	    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $line)" --parse_mode markdown
		fi
	done < ${TRIP_CHECKLIST_FILE}
}
list.search() {
	local regex

	if [[ "${callback_query_data}" == "btn_trip_outrosX" ]]; then
		regex='❌'
	elif [[ "${callback_query_data}" == "btn_trip_outrosV" ]]; then
		regex='✅'
	fi

	if [[ "${callback_query_data}" =~ btn_trip_outros. ]] ; then
		while read line; do
			if [[ $(echo $line | grep -E -v '^Comprar' | grep -E -v '^Passagens' | grep -E -v '^Trem'| grep -E "${regex}") ]]; then
				ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "$(echo -e ${_message})"
		  	    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $line)" --parse_mode markdown
			fi
		done < ${TRIP_CHECKLIST_FILE}
	fi

	if [[ "${callback_query_data}" == "btn_trip_comprarX" ]]; then
		regex='❌'
	elif [[ "${callback_query_data}" == "btn_trip_comprarV" ]]; then
		regex='✅'
	fi

	if [[ "${callback_query_data}" =~ btn_trip_comprar. ]] ; then
		while read line; do
			if [[ $(echo $line | grep -E '^Comprar' | grep -E "${regex}") ]]; then
				ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "$(echo -e ${_message})"
		  	    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $line)" --parse_mode markdown
			fi
		done < ${TRIP_CHECKLIST_FILE}
	fi

	if [[ "${callback_query_data}" == "btn_trip_passagensX" ]]; then
		regex='❌'
	elif [[ "${callback_query_data}" == "btn_trip_passagensV" ]]; then
		regex='✅'
	fi

	if [[ "${callback_query_data}" =~ btn_trip_passagens. ]] ; then
		while read line; do
			if [[ $(echo $line | grep -E '^Passagens' | grep -E "${regex}") ]]; then
				ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "$(echo -e ${_message})"
		  	    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $line)" --parse_mode markdown
			fi
		done < ${TRIP_CHECKLIST_FILE}
	fi

	if [[ "${callback_query_data}" == "btn_trip_tremX" ]]; then
		regex='❌'
	elif [[ "${callback_query_data}" == "btn_trip_tremV" ]]; then
		regex='✅'
	fi

	if [[ "${callback_query_data}" =~ btn_trip_trem. ]] ; then
		while read line; do
			if [[ $(echo $line | grep -E '^Trem' | grep -E "${regex}") ]]; then
				ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "$(echo -e ${_message})"
			    ShellBot.sendMessage --chat_id ${callback_query_message_chat_id[$id]} --text "$(echo -e $line)" --parse_mode markdown
			fi
		done < ${TRIP_CHECKLIST_FILE}
	fi

}

trip.btn_loc() {
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "--->" --reply_markup "$keyboard_loc"
}

trip.all_cities() {
	local cidades

	cidades="/madrid\n\n/dublin\n\n/liverpool\n\n/londres\n\n/berlim\n\n/amsterdam\n\n/bruxelas\n\n/paris\n\n/veneza\n\n/roma"
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${cidades})" --parse_mode markdown
}

trip.cities() {
	local city city_file message message_base

	message_base="*🗺️🌴 === EURO 💑 TRIP === ☃️🛩️*\n\n"

	city_file="${BASEDIR}/texts/trip_cities.csv"
	city=$1

	message="$(echo -e ${message_base})\n\n"
	message+="A viagem para ${city} vai ser no dia\n*$(cat ${city_file} | grep ${city} | cut -d',' -f2)*\n"
	message+="Vocês irão deixar ${city} no dia\n*$(cat ${city_file} | grep ${city} | cut -d',' -f3)*\n"
    message+="As passagens estão *$(cat ${city_file} | grep ${city} | cut -d',' -f5)*\n\n"

	if [[ ${city} == "Madri" ]]; then
			message+="Esse trecho vai ser de $(cat ${city_file} | grep ${city} | cut -d',' -f4)"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/14"
    fi
	if [[ ${city} == "Dublin" ]]; then
			message+="Esse trecho vai ser de $(cat ${city_file} | grep ${city} | cut -d',' -f4)"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/16"
    fi
		if [[ ${city} == "Liverpool" ]]; then
			message+="Esse trecho vai ser de $(cat ${city_file} | grep ${city} | cut -d',' -f4)"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/18"
    fi
		if [[ ${city} == "Londres" ]]; then
			message+="Esse trecho vai ser de $(cat ${city_file} | grep ${city} | cut -d',' -f4)"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/18"
    fi
		if [[ ${city} == "Berlim" ]]; then
			message+="Esse trecho vai ser de $(cat ${city_file} | grep ${city} | cut -d',' -f4)"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/21"
    fi
		if [[ ${city} == "Amsterdam" ]]; then
			message+="Esse trecho vai ser de $(cat ${city_file} | grep ${city} | cut -d',' -f4)"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/22"
    fi
		if [[ ${city} == "Bruxelas" ]]; then
			message+="Esse trecho vai ser especial pois irão para Duvel e Bruges"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/23"
    fi
		if [[ ${city} == "Paris" ]]; then
			message+="Esse trecho vai ser de $(cat ${city_file} | grep ${city} | cut -d',' -f4)"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/25"
    fi
		if [[ ${city} == "Veneza" ]]; then
			message+="Esse trecho vai ser de $(cat ${city_file} | grep ${city} | cut -d',' -f4)"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/27"
    fi
		if [[ ${city} == "Roma" ]]; then
			message+="Esse trecho é a volta para casa!!!"
			ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
			days.remaining "1 2020/01/28"
	fi
}
