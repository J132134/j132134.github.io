ratio = .8
size =
  small: {width: 544, height: 680}
  large: {width: 624, height: 780}

form = $('form')
canvas = $('<canvas></canvas>')
result = $('.result img')

context = canvas[0].getContext '2d'

form.on 'submit', (e) -> e.preventDefault()

$('input[type=file]').on 'change', ->
  return if not file = @files?[0]
  text = form[0].text.value.replace /\\u([0-9A-F]{4})/gi, (match, group) -> String.fromCharCode parseInt group, 16
  position = form[0].position.value

  canvas.attr 'width', cw = size[form[0].size.value].width
  canvas.attr 'height', ch = size[form[0].size.value].height

  result.attr 'width', cw / 2
  result.attr 'height', ch / 2

  render = new FileReader()
  render.onload = (e) ->
    image = new Image()
    image.onload = ->
      width = image.width
      height = image.height
      if (width / height) > ratio
        width = height * ratio
        sx = (image.width - width) / 2
      else if (width / height) < ratio
        height = width / ratio
        sy = (image.height - height) / 2

      context.drawImage image, sx or 0, sy or 0, width, height, 0, 0, cw, ch
      context.font = '40px Compact'
      context.fillStyle = form[0].color.value
      context.fillText text, 20, (if position is 'top' then 50 else ch - 30)

      result[0].src = canvas[0].toDataURL 'image/jpeg', 1
      result.show()
      form.hide()
    image.src = e.target.result
  render.readAsDataURL file
