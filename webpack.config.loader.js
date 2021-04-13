const path = require('path');

module.exports = {
  mode: 'production',
  entry: './loader.js',
  output: {
    filename: 'loader.bundle.js',
    path: path.resolve(__dirname, 'dist'),
  }
};
