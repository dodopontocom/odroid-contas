#!/bin/bash
# 

# procura no site do tenda atacado e retorna o primeiro resultado do produto e preco

product.search() {
  local product_name first_found product_price message

  product_name=${message_text/ /%20}
  echo ${product_name}
  first_found="$(curl -sSS https://www.tendaatacado.com.br/${product_name} | grep "escaped-name" | cut -d'>' -f2 | cut -d'<' -f1 | head -1)"
  echo ${first_found}
  product_price="$(curl -sSS https://www.tendaatacado.com.br/${product_name} | grep -A11 "${first_found}" | tail -1 | sed "s:[\t ]::g")"

  if [[ ${first_found} ]] && [[ ${product_price} ]]; then
          message="Voce pode encontrar ${message_text} no *\`TENDA ATACADISTA\`*\n\n"
          message+="*Produto/Marca:* ${first_found//[&#]/}\n\n"
          message+="*Preco:* ---> ${product_price}"

          ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  else
          message="Produto nao encontrado..."
          ShellBot.sendMessage --chat_id ${message_chat_id[$id]} --text "$(echo -e ${message})" --parse_mode markdown
  fi

}

