#!/bin/bash

site.upload() {
    local message
    
    message="$(git --work-tree=${CONSTRUTORA_WEBSITE_REPO_PATH}/ \
                --git-dir=${CONSTRUTORA_WEBSITE_REPO_PATH}/.git pull origin develop)"
    
    ShellBot.sendMessage --chat_id ${message_chat_id[$id]} \
					--text "*$(echo -e ${message})*" \
					--parse_mode markdown

}