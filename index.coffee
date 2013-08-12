((obj) ->
  if typeof module isnt 'undefined'
    module.exports = obj
  else
    window.minimg = obj
) (input, maxWidth, maxHeight, callback) ->
  canvas = document.createElement 'canvas'
  ctx = canvas.getContext '2d'

  file = input.files[0]

  imageReady = ->
    width = img.width
    height = img.height

    if width > height
      if width > maxWidth
        height *= maxWidth / width
        width = maxWidth
    else if height > maxHeight
      width *= maxHeight / height
      height = maxHeight

    canvas.width = width
    canvas.height = height
    ctx = canvas.getContext '2d'
    ctx.drawImage img, 0, 0, width, height

    #dataurl = canvas.toDataURL 'image/jpeg'
    callback null, canvas

  img = document.createElement 'img'
  img.onload = -> imageReady()
  reader = new FileReader()
  reader.onload = (e) -> img.src = e.target.result
  reader.readAsDataURL file
