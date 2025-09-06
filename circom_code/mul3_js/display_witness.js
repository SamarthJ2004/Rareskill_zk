const fs = require("fs")
const util = require("util");

const filePath = "witness.wtns"

const data = fs.readFileSync(filePath)

let data_arr = new Uint8Array(data)

console.log(util.inspect(data_arr, { maxArrayLength: null, breakLength: Infinity }));
