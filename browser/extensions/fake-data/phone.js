function make() {
  const areaCodes = [
    `11`,
    `21`,
    `31`,
    `41`,
    `51`,
    `61`,
    `71`,
    `81`,
    `85`,
    `47`,
  ];
  const areaCode = areaCodes[Math.floor(Math.random() * areaCodes.length)];
  const firstDigit = `9`;
  let remainingDigits = ``;
  for (let i = 0; i < 8; i++) {
    remainingDigits += Math.floor(Math.random() * 10);
  }
  return areaCode + firstDigit + remainingDigits;
}

return make();
