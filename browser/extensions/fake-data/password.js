function fakePassword() {
  const email = fakeData.getLastGeneratedValue(`email`);
  return `A1${email}`;
}

return fakePassword();
