#!/bin/bash

# Script que carrega as configurações iniciais do bot

function_list=($(find ${BASEDIR}/functions -name "*.sh" | grep -v "init"))
for f in ${function_list[@]}; do
    source ${f}
done