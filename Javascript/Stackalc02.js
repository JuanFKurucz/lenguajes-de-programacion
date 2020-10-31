/*
Diego Bergara
Fernando Rakovsky
Juan Francisco Kurucz
Javier Martin
*/

let a = {
  code: ["1", "2", "+"],
  pos: 0,
  stack: [],
};

const methods = {
  "+": (a, b) => a + b,
  "-": (a, b) => a - b,
  "/": (a, b) => a / b,
  "*": (a, b) => a * b,
  "==": (a, b) => a == b,
  "!=": (a, b) => a != b,
  "<": (a, b) => a < b,
  "<=": (a, b) => a <= b,
  ">": (a, b) => a > b,
  ">=": (a, b) => a >= b,
  "!": (a) => !a,
  "&&": (a, b) => a && b,
  "||": (a, b) => a || b,
};

const evaluate = (state) => {
  console.log(state);
  if (state.pos >= state.code.length) {
    return state;
  }
  if (state.code[state.pos] in methods) {
    const method = methods[state.code[state.pos]];
    const variables = [...Array(method.length)].map(() => state.stack.pop());
    state.stack.push(method(...variables));
  } else {
    const number = parseFloat(state.code[state.pos]);
    if (!Number.isNaN(number)) {
      state.stack.push(number);
    }
  }
  state.pos++;
  evaluate(state);
};

// CASOS DE PRUEBA
// 1 2 3 * + = 7
// 22 33 4 - * = 638
// 1 10 5 / + = 3
// 10 2 10 5 / + * = 40
// 5 5 5 5 5 1 - * + / + = 5
// * + - = 435
// 25 10 4 8 9 3 + - + * + = 25
// 15 + * = 17400
// 2 / 4 + = 8704
// 45 20 45450 37 25 108 25 35 12 - * + / + + - + = -45422
let stack = [];

const states = [
  {
    code: "1 2 3 * +".split(" "),
    pos: 0,
    stack,
  },
  {
    code: "22 33 4 - *".split(" "),
    pos: 0,
    stack: [],
  },
  {
    code: "1 10 5 / +".split(" "),
    pos: 0,
    stack: [],
  },
  {
    code: "10 2 10 5 / + *".split(" "),
    pos: 0,
    stack: [],
  },
  {
    code: "5 5 5 5 5 1 - * + / +".split(" "), //, "3"],//, ">"],
    pos: 0,
    stack: [],
  },
  {
    code: "* + -".split(" "),
    pos: 0,
    stack: [],
  },
  {
    code: "25 10 4 8 9 3 + - + * +".split(" "),
    pos: 0,
    stack: [],
  },
  {
    code: "15 + *".split(" "),
    pos: 0,
    stack: [],
  },
  {
    code: "2 / 4 +".split(" "),
    pos: 0,
    stack: [],
  },
  {
    code: "45 20 45450 37 25 108 25 35 12 - * + / + + - +".split(" "),
    pos: 0,
    stack: [],
  },
];

evaluate(a);
