#!/usr/bin/env bash

_RADIO_UNTICKED="⚪"
_RADIO_TICKED="🔘"

_RADIO_OPTIONS=(green red yellow none)

_COMMAND="${1:-test}"

button.radio_init() {
	local button1 keyboard title count
	title="*Select one option:*"
	count=1

	button1=''

	for i in $(echo ${_RADIO_OPTIONS[@]}); do
		ShellBot.InlineKeyboardButton --button 'button1' --text "${_RADIO_UNTICKED} ${i}" --callback_data "tick_${i%%/*}" --line ${count}
		count=$((count+1))
	done

	keyboard="$(ShellBot.InlineKeyboardMarkup -b 'button1')"

	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e ${title})" \
                	        --parse_mode markdown \
                        	--reply_markup "$keyboard"
}

button.radio_tick() {
	local button2 keyboard2 count
	count=1

	button2=''
	
	for i in $(echo ${_RADIO_OPTIONS[@]}); do
		if [[ "${callback_query_data[$id]}" == "tick_${i%%/*}" ]]; then
			ShellBot.InlineKeyboardButton --button 'button2' --text "${_RADIO_TICKED} ${i}" --callback_data "untick_${i%%/*}" --line ${count}
		else
			ShellBot.InlineKeyboardButton --button 'button2' --text "${_RADIO_UNTICKED} ${i}" --callback_data "tick_${i%%/*}" --line ${count}
		fi
		count=$((count+1))
	done

	keyboard2="$(ShellBot.InlineKeyboardMarkup -b 'button2')"

	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "ticking ${callback_query_data[$id]}..."

        ShellBot.editMessageReplyMarkup --chat_id ${callback_query_message_chat_id[$id]} \
				--message_id ${callback_query_message_message_id[$id]} \
                            	--reply_markup "$keyboard2"
}

button.radio_untick() {
        local button3 keyboard3 count
	count=1

        button3=''

	for i in $(echo ${_RADIO_OPTIONS[@]}); do
		ShellBot.InlineKeyboardButton --button 'button3' --text "${_RADIO_UNTICKED} ${i}" --callback_data "tick_${i%%/*}" --line ${count}
		count=$((count+1))
	done

        keyboard3="$(ShellBot.InlineKeyboardMarkup -b 'button3')"

        ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "unticking..."

        ShellBot.editMessageReplyMarkup --chat_id ${callback_query_message_chat_id[$id]} \
                                --message_id ${callback_query_message_message_id[$id]} \
                                --reply_markup "$keyboard3"
}

# source ${BASEDIR}/ShellBot.sh
# ShellBot.init --token "${TELEGRAM_TOKEN}" --monitor --flush

# while :
# do
# 	ShellBot.getUpdates --limit 100 --offset $(ShellBot.OffsetNext) --timeout 30

# 	for id in $(ShellBot.ListUpdates)
# 	do
# 	(
# 		ShellBot.watchHandle --callback_data ${callback_query_data[$id]}

# 		if [[ ${message_entities_type[$id]} == bot_command ]]; then
# 			case ${message_text[$id]} in
# 				"/${_COMMAND}")
# 					init.button
# 					;;
# 			esac
# 		fi

# 		for i in $(echo ${_RADIO_OPTIONS[@]}); do
# 			case ${callback_query_data[$id]} in
# 				"tick_${i%%/*}")
# 					tick.button
# 					;;
# 				"untick_${i%%/*}")
# 					untick.button
# 					;;
# 			esac
# 		done

# 	) &
# 	done
# done
