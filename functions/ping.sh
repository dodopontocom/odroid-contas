#!/bin/bash
#

ping.pong() {
  local message

  message="* P o 0O o O n G 🏓*"
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
}
