const assert = require('assert');
const { expect } = require('chai');

describe('Basic Chai Test of an array', () => {
  const exampleArray = new Array(3);

  it('should give the right arry lengt', () => {
    expect(exampleArray).to.have.lengthOf(3);
  });
});

describe('Basic Mocha String Test', () => {
  it('should return number of charachters in a string', () => {
    assert.equal('Hello'.length, 5);
  });
  it('should return first charachter of the string', () => {
    assert.equal('Hello'.charAt(0), 'H');
  });
});
