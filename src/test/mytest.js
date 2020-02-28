const assert = require('assert');
const { expect } = require('chai');

describe('Basic Chai Test', () => {
  it('should return number of charachters in a string', () => {
    expect(true);
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
