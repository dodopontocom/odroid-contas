#!/bin/bash
#
start() {
  message="ola "
  message+=${message_from_first_name}
  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e "${message})"
}
