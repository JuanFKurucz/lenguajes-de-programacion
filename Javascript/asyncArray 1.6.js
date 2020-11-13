// // Version con wraper
async function asyncMap(array, fn) {
  return new Promise(async (resolve, reject) => {
    try {
      let result = [];
      for (elem of array) {
        let newElem = await fn(elem);
        result.push(newElem);
      }
      resolve(result);
    } catch (error) {
      reject(error);
    }
  });
}

async function asyncFilter(array, fn) {
  return new Promise(async (resolve, reject) => {
    try {
      let result = [];
      for (elem of array) {
        let newElem = await fn(elem);
        if (newElem) {
          result.push(elem);
        }
      }
      resolve(result);
    } catch (error) {
      reject(error);
    }
  });
}

async function asyncReduce(array, fn) {
  return new Promise(async (resolve, reject) => {
    try {
      let result = 0;
      for (elem of array) {
        result = await fn(result, elem);
      }
      resolve(result);
    } catch (error) {
      reject(error);
    }
  });
}

async function asyncForEach(array, fn) {
  return new Promise(async (resolve, reject) => {
    try {
      for (elem of array) {
        await fn(elem);
      }
      resolve(true);
    } catch (error) {
      reject(error);
    }
  });
}

/* TESTS */
const unArray = [1, 2, 3];
const timesTwo = (elem) => Promise.resolve(elem * 2);
const greaterThanTwo = (elem) => Promise.resolve(elem > 2);
const reducer = (accumulator, currentValue) =>
  Promise.resolve(accumulator + currentValue);
const logElement = (elem) => Promise.resolve(console.log(elem));
const delayMultTwo = async (elem) =>
  new Promise((resolve) => {
    setTimeout(() => resolve(elem * 2), 100);
  });

/* Segunda prueba*/
const init = async () => {
  try {
    // MAP
    console.log("before Map");
    let result = await asyncMap([1, 2, 3], delayMultTwo);
    console.log(result);
    console.log(`Resultado de map: ${result} = [2,4,6]`);
    console.log("after map -----------");

    // FILTER
    console.log("before Filter");
    result = await asyncFilter([1, 2, 3], greaterThanTwo);
    console.log(result);
    console.log(`Resultado de filter: ${result} = [1,3]`);
    console.log("after Filter -----------");

    // REDUCE
    console.log("before Reduce");
    result = await asyncReduce([1, 2, 3, 4], reducer);
    console.log(result);
    console.log(`Resultado de Reduce: ${result} = 10`);
    console.log("after Reduce -----------");

    // FOREACH
    console.log("before forEach");
    result = await asyncForEach([1, -2, 3], logElement);
    console.log(result);
    console.log(`Resultado de forEach: ? = 10`);
    console.log("after forEach -----------");
  } catch (error) {
    console.log(error);
    // handle error
  }
};
init();
