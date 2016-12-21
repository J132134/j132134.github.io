path = require 'path'

src = path.join __dirname, 'src/'
dist = path.join __dirname, 'dist/'

module.exports =
  path:
    src:
      jade: path.join src, 'jade/'
      stylus: path.join src, 'stylus/'
      coffee: path.join src, 'coffee/'
      images: path.join __dirname, 'images/'
      fonts: path.join __dirname, 'fonts/'
    dist:
      root: dist
      css: path.join dist, 'css/'
      js: path.join dist, 'js/'
      img: path.join dist, 'img/'
      font: path.join dist, 'font/'

  option:
    jade:
      dev:
        pretty: true
      prod:
        pretty: false

    stylus:
      dev:
        compress: false
        linenos: false
      prod:
        compress: true
        linenos: false

    base64:
      baseDir: __dirname
      extensionsAllowed: ['.jpg', '.png']