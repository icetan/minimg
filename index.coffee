((obj) ->
  if typeof module isnt 'undefined'
    module.exports = obj
  else
    window.minimg = obj
) minimg = (input, opt, callback) ->
  img = new Image
  if not callback
    callback = opt
    opt = null

  scaleImage = (opt) ->
    { max: { width:maxWidth, height:maxHeight }, crop, smooth } = opt
    smooth = Math.max 0, Math.min((if smooth? then smooth else 0.5) * 0.9, 1)

    width = img.width
    height = img.height

    byWidth = -> if width > maxWidth then maxWidth / width else 1
    byHeight = -> if height > maxHeight then maxHeight / height else 1

    scale = (
      if width < height
        if crop then byWidth() else byHeight()
      else
        if crop then byHeight() else byWidth()
    )

    fw = Math.round if crop then Math.min maxWidth, width else width * scale
    fh = Math.round if crop then Math.min maxHeight, height else height * scale
    dw = Math.round fw / scale
    dh = Math.round fh / scale

    while true
      sw = dw
      sh = dh
      sx = img.width / 2 - sw / 2
      sy = img.height / 2 - sh / 2

      dw = Math.round dw * smooth
      dh = Math.round dh * smooth

      if dw <= fw or dh <= fh
        dw = fw
        dh = fh

      canvas = document.createElement 'canvas'
      ctx = canvas.getContext '2d'
      canvas.width = dw
      canvas.height = dh
      ctx.drawImage img, sx, sy, sw, sh, 0, 0, dw, dh

      if dw is fw and dh is fh
        return canvas
      else
        img = canvas

  img.onload = -> callback null, (if opt then scaleImage(opt) else scaleImage)
  reader = new FileReader()
  reader.onload = (e) -> img.src = e.target.result
  reader.readAsDataURL input.files[0]
  return
