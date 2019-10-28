var clickListener = document.getElementByID("module");
lockMouse = function(){
  var img = document.createElement("image");
  img.src = "cursor.png";
  img.x = event.clientX;
  img.y = event.clientY;
  var sty = document.getElementByTagname("style");
  sty.innerHTML = "html { cursor: none; }";
}
clickerListener.onclick = lockMouse();
