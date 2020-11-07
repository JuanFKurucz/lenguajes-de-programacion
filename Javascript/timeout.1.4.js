const delay = (timeout) =>
  new Promise((resolve) => {
    setTimeout(() => resolve(Date.now()), timeout);
  });

const timeout = (promise, miliTime) =>
  Promise.race([
    promise,
    delay(miliTime).then(() => {
      throw new Error("Timeout!");
    }),
  ]);

timeout(delay(1000), 1500).then(console.log).catch(console.log);
timeout(delay(2000), 1500).then(console.log).catch(console.log);
