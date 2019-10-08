#!/bin/bash

days.remaining() {
  local days message
  
  days=$1
  if [[ ${days} ]]; then
    message="✅ $(days_from_today ${days}) dias"
	  ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  else
    message="✅ $(days_from_today "2020-01-14") dias"
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})"
  fi
}
