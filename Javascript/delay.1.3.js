const delay = (timeout) =>
  new Promise((resolve) => {
    setTimeout(() => resolve(Date.now()), timeout);
  });

delay(1500).then(console.log);
