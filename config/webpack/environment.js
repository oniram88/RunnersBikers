const {environment} = require('@rails/webpacker');
const vue = require('./loaders/vue');
const webpack = require('webpack');

const UglifyJsPlugin = require('uglifyjs-webpack-plugin');

environment.plugins.set('UglifyJs',
  new UglifyJsPlugin()
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
