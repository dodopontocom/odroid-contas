#!/bin/bash
#
export BASEDIR="$(cd $(dirname ${BASH_SOURCE[0]}) >/dev/null 2>&1 && pwd)"

source ${BASEDIR}/.definitions.sh
#source ${BASEDIR}/functions/init.sh

#TBOTLIB
source ${BASEDIR}/tbotlib.sh

tbotlib.use.WelcomeMessage
tbotlib.use.BooleanInlineButton

motion_button="motion_camera_switch"

while :
do
	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30

	for id in $(ShellBot.ListUpdates)
	do
	(
		ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

        [[ ${message_new_chat_member_id[$id]} ]] && WelcomeMessage.send --short --message "I like you"
		
        case ${callback_query_data[$id]} in
            tick_to_false.${motion_button}) BooleanInlineButton.tick_to_false ${motion_button} ;;
            tick_to_true.${motion_button}) BooleanInlineButton.tick_to_true ${motion_button} ;;
		esac
		
		if [[ ${message_entities_type[$id]} == bot_command ]]; then
			if [[ "$(echo ${message_text[$id]%%@*} | grep "^\/switch" )" ]]; then
				BooleanInlineButton.init --true-value "ON" --false-value "OFF" --button-name "${motion_button}"
            fi
		fi
	) &
	done
done