lockMouse = function(){
  var img = document.createElement("image");
  document.body.appendChild(img);
  img.src = "cursor.png";
  img.x = event.clientX;
  img.y = event.clientY;
  var sty = document.getElementByTagName("style");
  sty.innerHTML = "html { cursor: none; }";
}
document.addEventListener("click", function(){
  lockMouse();
});
