function lockMouse(e) {
  var img = document.createElement("image");
  img.src = "cursor.png";
  img.style = "position: absolute; left: " + e.client.x + "; up: " + e.client.y + ";";
  document.getElementById("body").appendChild(img);
  var sty = document.getElementById("sty");
  sty.innerHTML = `html {
	                  cursor: none;
                   }`;
}
document.addEventListener("click", function() {
	lockMouse("click"))
});

