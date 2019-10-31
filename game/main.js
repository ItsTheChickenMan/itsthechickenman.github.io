function lockMouse(e) {
  var img = document.createElement("image");
  document.body.appendChild(img);
  img.src = "cursor.png";
  img.x = e.clientX;
  img.y = e.clientY;
  var sty = document.getElementByTagName("style");
  sty.innerHTML = "html { cursor: none; }";
}
document.addEventListener("click", lockMouse);
