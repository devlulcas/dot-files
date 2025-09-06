function make() {
  const length = 12;
  const lowers = `abcdefghijklmnopqrstuvwxyz`;
  const uppers = `ABCDEFGHIJKLMNOPQRSTUVWXYZ`;
  const digits = `0123456789`;
  const symbols = `!@#$%^&*()-_=+[]{}`;
  const all = lowers + uppers + digits + symbols;

  let passwordChars = [];
  passwordChars.push(lowers[Math.floor(Math.random() * lowers.length)]);
  passwordChars.push(uppers[Math.floor(Math.random() * uppers.length)]);
  passwordChars.push(digits[Math.floor(Math.random() * digits.length)]);
  passwordChars.push(symbols[Math.floor(Math.random() * symbols.length)]);

  for (let i = passwordChars.length; i < length; i++) {
    passwordChars.push(all[Math.floor(Math.random() * all.length)]);
  }

  for (let i = passwordChars.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    const temp = passwordChars[i];
    passwordChars[i] = passwordChars[j];
    passwordChars[j] = temp;
  }

  return passwordChars.join(``);
}

return make();
