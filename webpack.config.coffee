_ = require 'lodash'
path = require 'path'
webpack = require 'webpack'

config = require './gulp.config'
src = config.path.src

base =
  entry:
    watch: path.join src.coffee, 'watch.coffee'

  output:
    filename: '[name].js'

  module:
    loaders: [
      {test: /\.coffee$/, loader: 'coffee-loader'}
    ]

  resolve:
    root: path.resolve './src/coffee'
    extensions: ['', '.coffee', '.js']

plugins =
  banner: [
    new webpack.BannerPlugin('"use strict";', {
      raw: true
    })
  ]
  shim: [
    new webpack.ProvidePlugin({
      _: 'lodash'
      $: 'jquery'
      jQuery: 'jquery'
      'window.jQuery': 'jquery'
    })
  ]
  uglify: [
    new webpack.optimize.UglifyJsPlugin({
      minimize: true
      sourceMap: false
      output:
        comments: false
      compress:
        drop_debugger: false
        hoist_funs: true
        hoist_vars: true
        cascade: false
    })
  ]

module.exports =
  dev: _.assign
    cache: false
    debug: true
    devtool: '#source-map'
    plugins: _.concat plugins.banner, plugins.shim
  , base

  prod: _.assign
    cache: false
    debug: false
    plugins: _.concat plugins.banner, plugins.shim, plugins.uglify
  , base
