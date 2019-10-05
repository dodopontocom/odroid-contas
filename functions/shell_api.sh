#!/bin/bash

api.dinamic() {
	
	local api_git_url tmp_folder
	api_git_url=https://github.com/shellscriptx/shellbot.git
	tmp_folder=/tmp/$(random.helper)

	git clone ${api_git_url} ${tmp_folder}

	cp ${tmp_folder}/ShellBot.sh ${BASEDIR}/
	#rm -fr ${tmp_folder}

}
