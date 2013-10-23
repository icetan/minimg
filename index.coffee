((obj) ->
  if typeof module isnt 'undefined'
    module.exports = obj
  else
    window.minimg = obj
) (input, maxWidth, maxHeight, callback) ->
  if not (input instanceof HTMLInputElement)
    callback = maxWidth
    { input, max: { width:maxWidth, height:maxHeight }, crop } = input

  canvas = document.createElement 'canvas'
  ctx = canvas.getContext '2d'

  file = input.files[0]

  imageReady = ->
    width = img.width
    height = img.height

    byWidth = ->
      if width > maxWidth then maxWidth / width else 1
    byHeight = ->
      if height > maxHeight then maxHeight / height else 1

    scale = (
      if width < height
        if crop then byWidth() else byHeight()
      else
        if crop then byHeight() else byWidth()
    )
    dw = if crop then maxWidth else width * scale
    dh = if crop then maxHeight else height * scale

    canvas.width = dw
    canvas.height = dh
    ctx = canvas.getContext '2d'
    #if crop and crop.width and crop.height
    sw = Math.min maxWidth / scale, width
    sh = Math.min maxHeight / scale, height
    sx = width / 2 - sw / 2
    sy = height / 2 - sh / 2
    ctx.drawImage img, sx, sy, sw, sh, 0, 0, dw, dh

    callback null, canvas

  img = document.createElement 'img'
  img.onload = -> imageReady()
  reader = new FileReader()
  reader.onload = (e) -> img.src = e.target.result
  reader.readAsDataURL file
