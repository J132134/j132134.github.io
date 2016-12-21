require 'coffee-script'

path = require 'path'
del = require 'del'
gulp = require 'gulp'
jade = require 'gulp-jade'
stylus = require 'gulp-stylus'
base64 = require 'gulp-css-base64'
webpack = require 'webpack-stream'
sourcemaps = require 'gulp-sourcemaps'
inline = require 'gulp-inline-source'
connect = require 'gulp-connect'

## variables
config =
  gulp: require './gulp.config'
  webpack: require './webpack.config'

option = config.gulp.option
src = config.gulp.path.src
dist = config.gulp.path.dist

error = -> this.emit 'end'

## private tasks
gulp.task 'clean', ->
  del dist.root

gulp.task 'copy', ->
  gulp.src path.join src.images, '**/*'
  .pipe gulp.dest dist.img
  gulp.src path.join src.fonts, '*'
  .pipe gulp.dest dist.font

# build
gulp.task 'jade:dev', ->
  gulp.src path.join src.jade, '**/*.jade'
  .pipe jade option.jade.dev
  .on 'error', error
  .pipe gulp.dest dist.root
  .pipe connect.reload()

gulp.task 'jade', ->
  gulp.src path.join src.jade, '**/*.jade'
  .pipe jade option.jade.prod
  .pipe gulp.dest dist.root

gulp.task 'stylus:dev', ->
  gulp.src path.join src.stylus, '*.styl'
  .pipe sourcemaps.init()
  .pipe stylus option.stylus.dev
  .on 'error', error
  .pipe base64 option.base64
  .pipe sourcemaps.write '.'
  .pipe gulp.dest dist.css
  .pipe connect.reload()

gulp.task 'stylus', ->
  gulp.src path.join src.stylus, '*.styl'
  .pipe stylus option.stylus.prod
  .pipe base64 option.base64
  .pipe gulp.dest dist.css

gulp.task 'webpack:dev', ->
  gulp.src path.join src.coffee, 'app/entry.coffee'
  .pipe webpack config.webpack.dev
  .on 'error', error
  .pipe gulp.dest dist.js
  .pipe connect.reload()

gulp.task 'webpack', ->
  gulp.src path.join src.coffee, 'app/entry.coffee'
  .pipe webpack config.webpack.prod
  .pipe gulp.dest dist.js

gulp.task 'watch', ['jade:dev', 'stylus:dev'], ->
  gulp.watch '**/*.jade', {cwd: src.jade}, ['jade:dev']
  gulp.watch '**/*.styl', {cwd: src.stylus}, ['stylus:dev']
  gulp.watch '**/*.coffee', {cwd: src.coffee}, ['webpack:dev']
  gulp.watch '**/*', {cwd: src.images}, ['stylus:dev']

gulp.task 'connect', ->
  connect.server
    root: dist.root
    port: 3000
    livereload: true

gulp.task 'inline', ['jade', 'stylus', 'webpack'], ->
  gulp.src path.join dist.root, '*.html'
  .pipe inline()
  .pipe gulp.dest dist.root

gulp.task 'clean:after', ['inline'], ->
  del [dist.css, dist.js, dist.img]

## public tasks
gulp.task 'default', ->
  console.log 'Run "gulp serve" or "gulp build"'

gulp.task 'serve', ['clean'], ->
  gulp.start ['copy', 'jade:dev', 'stylus:dev', 'webpack:dev', 'watch', 'connect']

gulp.task 'build', ['clean'], ->
  gulp.start ['copy', 'jade', 'stylus', 'webpack', 'inline', 'clean:after']