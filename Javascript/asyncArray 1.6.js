// https://medium.com/tarkalabs/async-await-wrapper-for-callback-style-javascript-code-cde2b699122f
awesomeFunction(10, (result, error) => {
  // if error object is present, handle accordingly
  // else, use the results and do something
});

// Version con wraper
async function awesomeFunctionWrapper(input) {
  return await new Promise((resolve, reject) => {
    awesomeFunction(input, (result, err) => {
      if (err) {
        reject(err);
      } else {
        resolve(result);
      }
    });
  });
}

/* Estas son nuestras funciones */
// Version con wraper
async function asyncMap(array, fn) {
  const result = await new Promise((resolve, reject) => {
    if (result === undefined) {
      reject(new Error("Error en map"));
    } else {
      resolve(result);
    }
  });
  return result;
}

// async function asyncMap(array, fn) {
//     return array.map(fn);
// }

async function asyncFilter(array, fn) {
  return array.filter(fn);
}

async function asyncReduce(array, fn) {
  return array.reduce(fn);
}

async function asyncForEach(array, fn) {
  return array.forEach(fn);
}

/* TESTS */
const unArray = [2, 3, 4];
const timesTwo = (elem) => elem * 2;
const greaterThanTwo = (elem) => elem > 2;
const reducer = (accumulator, currentValue) => accumulator + currentValue;
const logElement = (elem) => console.log(elem);

console.log(asyncMap(unArray, timesTwo)); // Promise { [ 4, 6, 8 ] }
console.log(asyncFilter(unArray, greaterThanTwo)); // Promise { [ false, true, true ] }
console.log(asyncReduce(unArray, reducer)); // Promise { 9 }
console.log(asyncForEach(unArray, logElement)); // 2 / 3 / 4
