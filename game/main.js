function lockMouse(e) {
  var img = document.createElement("image");
  img.src = "cursor.png";
  img.style = "position: absolute; left: " + e.x + "; up: " + e.y + ";";
  document.body.appendChild(img);
  var sty = document.getElementsByTagName("style");
  sty.innerHTML = "html { cursor: none; }";
}
document.addEventListener("click", lockMouse);

