module.exports = {
  env: {
    browser: true,
    es6: true,
    node: true,
    mocha: true,
  },
  extends: [
    'plugin:vue/essential',
    'airbnb-base',
  ],
  globals: {
    Atomics: 'readonly',
    SharedArrayBuffer: 'readonly',
  },
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'module',
  },
  plugins: [
    'vue',
  ],
  rules: {
  },
  globals: {
    web3: true,
    contract: true,
    Buffer: true,
    process: true,
    assert: true,
    artifacts: true,
    Atomics: 'readonly',
    SharedArrayBuffer: 'readonly',
  },
};
