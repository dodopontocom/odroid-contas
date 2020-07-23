#!/usr/bin/env bash

_FALSE="⛔"
_TRUE="✅"

#======================== Comment one or another to see the diferrence ================
#_BOOL_OPTIONS=(${_FALSE} ${_TRUE})
_BOOL_OPTIONS=(OFF ON)
#======================================================================================

_COMMAND="${1:-test}"

button.bool_init() {
	local button1 keyboard title
	title="*Switch:*"

	button1=''

	ShellBot.InlineKeyboardButton --button 'button1' \
		--text "${_BOOL_OPTIONS[0]}" \
		--callback_data "tick_to_false" \
		--line 1
	
	keyboard="$(ShellBot.InlineKeyboardMarkup -b 'button1')"

	ShellBot.deleteMessage --chat_id ${message_chat_id[$id]} --message_id ${message_message_id[$id]}
	ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
				--text "$(echo -e ${title})" \
				--parse_mode markdown \
                --reply_markup "$keyboard"
}

button.tick_to_false() {
	local button2 keyboard2

	button2=''
	
	ShellBot.InlineKeyboardButton --button 'button2' \
		--text "${_BOOL_OPTIONS[1]}" \
		--callback_data "tick_to_true" \
		--line 1

	keyboard2="$(ShellBot.InlineKeyboardMarkup -b 'button2')"

	ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "turning it true..."

    ShellBot.editMessageReplyMarkup --chat_id ${callback_query_message_chat_id[$id]} \
				--message_id ${callback_query_message_message_id[$id]} \
                            	--reply_markup "$keyboard2"
}

button.tick_to_true() {
    local button3 keyboard3

    button3=''

	ShellBot.InlineKeyboardButton --button 'button3' \
		--text "${_BOOL_OPTIONS[0]}" \
		--callback_data "tick_to_false" \
		--line 1

    keyboard3="$(ShellBot.InlineKeyboardMarkup -b 'button3')"

    ShellBot.answerCallbackQuery --callback_query_id ${callback_query_id[$id]} --text "turning it false..."

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

# 		case ${callback_query_data[$id]} in
# 			"tick_to_true")
# 				tick_to_true.button
# 				;;
# 			"tick_to_false")
# 				tick_to_false.button
# 				;;
# 		esac

# 	) &
# 	done
# done