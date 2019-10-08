#!/bin/bash

dinamic.api() {
	
	local api_git_url tmp_folder

	tmp_folder=/tmp/$(random.helper)

	echo "Baixando versão mais atual da API ShellBot"
	git clone ${API_GIT_URL} ${tmp_folder} > /dev/null
	
	echo "Habilitando a API"
	cp ${tmp_folder}/ShellBot.sh ${BASEDIR}/
	rm -fr ${tmp_folder}

}
