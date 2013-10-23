minimg
======

Scale your images in browser before upload.

```html
<input id="image" type="file" accept="image/*" capture="camera" />
<script src="minimg.js"></script>
<script>
  document.getElementById('image').onchange = function() {
    minimg(this, 600, 400, function(canvas) {
      console.log(canvas.toDataURL('image/jpeg'));
    });
  };
</script>
```
