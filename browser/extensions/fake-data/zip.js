function make() {
  const brazilianZipCodes = [
    `01310100`, // São Paulo - Paulista Avenue
    `20040020`, // Rio de Janeiro - Copacabana
    `30112000`, // Belo Horizonte - Centro
    `40070110`, // Salvador - Pelourinho
    `80010000`, // Curitiba - Centro
    `60165081`, // Fortaleza - Aldeota
    `52011900`, // Recife - Boa Viagem
    `70040010`, // Brasília - Asa Norte
    `90010150`, // Porto Alegre - Centro
    `66010000`, // Belém - Centro
    `78005000`, // Cuiabá - Centro
    `69005040`, // Manaus - Centro
    `57020000`, // Maceió - Centro
    `64000100`, // Teresina - Centro
    `49010000`, // Aracaju - Centro
  ];

  return brazilianZipCodes[
    Math.floor(Math.random() * brazilianZipCodes.length)
  ];
}

return make();
