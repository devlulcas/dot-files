function fakeEmail() {
  const domains = [
    `gmail.com`,
    `yahoo.com`,
    `hotmail.com`,
    `outlook.com`,
    `uol.com.br`,
  ];

  const names = [
    `joao`,
    `maria`,
    `carlos`,
    `ana`,
    `pedro`,
    `lucia`,
    `rafael`,
    `fernanda`,
    `bruno`,
    `camila`,
  ];

  const surnames = [
    `silva`,
    `santos`,
    `oliveira`,
    `souza`,
    `rodrigues`,
    `ferreira`,
    `alves`,
    `pereira`,
    `lima`,
    `gomes`,
  ];

  const name = names[Math.floor(Math.random() * names.length)];
  const surname = surnames[Math.floor(Math.random() * surnames.length)];
  const domain = domains[Math.floor(Math.random() * domains.length)];
  const number = Math.floor(Math.random() * 999) + 1;
  return `${name}.${surname}${number}@${domain}`;
}

return fakeEmail();
