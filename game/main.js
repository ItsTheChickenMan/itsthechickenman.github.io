var clickListener = document.getElementById("module");
lockMouse = function(){
  var img = document.createElement("image");
  img.src = "cursor.png";
  img.x = event.clientX;
  img.y = event.clientY;
  var sty = document.getElementByTagName("style");
  sty.innerHTML = "html { cursor: none; }";
}
clickListener.onclick = lockMouse();
