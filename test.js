// console.log(process.argv);

// console.log(process.argv.slice(2));
const argv = require('yargs-parser')(process.argv.slice(2));
console.log(argv, process.cwd());
