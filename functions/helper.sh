#!/bin/bash

exitOnError() {
  # usage: exitOnError <output_message> [optional: code (defaul:exit code)]
  code=${2:-$?}
  if [[ $code -ne 0 ]]; then
      if [ ! -z "$1" ]; then echo -e "ERROR: $1" >&2 ; fi
      echo "Exiting..." >&2
      exit $code
  fi
}

helper.validate_vars() {
  local vars_list=($@)
        
  for v in $(echo ${vars_list[@]}); do
    export | grep ${v} > /dev/null
    result=$?
    if [[ ${result} -ne 0 ]]; then
      echo "Dependency of ${v} is missing"
      echo "Exiting..."
      exit -1
    fi
  done
}

helper.replace_vars() {
  # Lê arquivo.
  conteudo=$(< $1)

  # Grupo
  re='([a-zA-Z0-9_]+)'

  # Lê o contéudo enquanto houver variáveis.
  #
  # Ex: ${var1}, ${var2} ...
  #
  while [[ $conteudo =~ \$\{$re\} ]]; do
      # Substitui a variável casada pelo seu valor (se presente), caso
      # contrário sinaliza com '!' o seu identificador para ser ignorado
      # nas próximas verificações.
      #
      # Ex: ${var_nula} -> !{var_nula}
      #
      [[ ${!BASH_REMATCH[1]} ]]                                   &&
      conteudo=${conteudo//$BASH_REMATCH/${!BASH_REMATCH[1]}}     ||
      conteudo=${conteudo//$BASH_REMATCH/!${BASH_REMATCH#?}}
  done

  # Restaura identificadores ignorados.
  while [[ $conteudo =~ \!\{$re\} ]]; do
      conteudo=${conteudo//$BASH_REMATCH/\$${BASH_REMATCH#?}}
  done

  # Gera o novo arquivo.
  echo "$conteudo" > $2
}

helper.date_arithimetic() {
  #credits https://gist.github.com/alvfig/f04130aef28e30f96b6bb63a5b81ba80

  secs()
  {
      TZ=UTC date --date="$1" '+%s'
  }

  date_diff()
  {
      expr \( `secs "$1"` - "$2" \) / 86400
  }

  days_from_today()
  {
      date_diff $1 "$(date +'%s')"
  }

  date_plus_days()
  {
      date --iso-8601 --date="$1 + $2 days"
  }

  today_plus_days()
  {
      date_plus_days "" $1
  }
  
  function=$1
  shift
  $function "$@"
}

