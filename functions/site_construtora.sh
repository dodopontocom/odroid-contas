#!/bin/bash

site.upload() {
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
					--text "*HELLO*" \
					--parse_mode markdown

}