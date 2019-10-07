#!/bin/bash

dinamic.api() {
	
	local api_git_url tmp_folder

	api_git_url=https://github.com/shellscriptx/shellbot.git
	tmp_folder=/tmp/$(random.helper)

	echo "Baixando versão mais atual da API ShellBot"
	git clone ${api_git_url} ${tmp_folder} > /dev/null
	
	echo "Habilitando a API"
	cp ${tmp_folder}/ShellBot.sh ${BASEDIR}/
	rm -fr ${tmp_folder}

}
