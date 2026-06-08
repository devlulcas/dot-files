function make() {
  const length = 12;
  const lowers = `abcdefghijklmnopqrstuvwxyz`;
  const uppers = `ABCDEFGHIJKLMNOPQRSTUVWXYZ`;
  const digits = `0123456789`;
  const symbols = `!@#$%^&*()-_=+[]{}`;
  const all = lowers + uppers + digits + symbols;
  const randomIndex = (max) => {
    if (globalThis.crypto?.getRandomValues) {
      const values = new Uint32Array(1);
      globalThis.crypto.getRandomValues(values);
      return values[0] % max;
    }

    return Math.floor(Math.random() * max);
  };

  let passwordChars = [];
  passwordChars.push(lowers[randomIndex(lowers.length)]);
  passwordChars.push(uppers[randomIndex(uppers.length)]);
  passwordChars.push(digits[randomIndex(digits.length)]);
  passwordChars.push(symbols[randomIndex(symbols.length)]);

  for (let i = passwordChars.length; i < length; i++) {
    passwordChars.push(all[randomIndex(all.length)]);
  }

  for (let i = passwordChars.length - 1; i > 0; i--) {
    const j = randomIndex(i + 1);
    const temp = passwordChars[i];
    passwordChars[i] = passwordChars[j];
    passwordChars[j] = temp;
  }

  return passwordChars.join(``);
}

return make();
