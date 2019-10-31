function lockMouse(e) {
  var img = document.createElement("image");
  img.src = "cursor.png";
  img.x = e.clientX; 
  img.y = e.clientY;
  document.body.appendChild(img);
  var sty = document.getElementsByTagName("style");
  sty.innerHTML = "html { cursor: none; }";
}
document.addEventListener("click", lockMouse);
//FUCK ME IN THE ah aH AH ASS
