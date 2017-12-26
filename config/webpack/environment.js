const {environment} = require('@rails/webpacker');
const vue = require('./loaders/vue');
const webpack = require('webpack');
const path = require('path');

const UglifyJsPlugin = require('uglifyjs-webpack-plugin');

environment.plugins.set('UglifyJs',
  new UglifyJsPlugin({
    parallel: true,
    uglifyOptions: {
      ecma: 6,
      compress: false // hangs without this
    },
    cache: path.join(__dirname, '../../tmp/webpack-cache/uglify-cache'),
  })
);

environment.plugins.set(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default']
  }),
);


environment.loaders.append('vue', vue);
module.exports = environment;
