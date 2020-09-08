const firstUpperCase = ([first, ...rest]) => first.toUpperCase() + rest.join('');
const firstLowerCase = ([first = '', ...rest]) => first.toLowerCase() + rest.join('');

module.exports = {
  firstUpperCase,
  firstLowerCase,
};
