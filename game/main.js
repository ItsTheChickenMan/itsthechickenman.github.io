function lockMouse(e) {
  var img = document.createElement("image");
  img.src = "cursor.png";
  img.style = "position: absolute; left: " + e.clientX + "; up: " + e.clientY + ";";
  document.getElementById("body").appendChild(img);
  var sty = document.getElementById("sty");
  sty.innerHTML = `html {
	                  cursor: none;
                   }`;
}
document.addEventListener("click", lockMouse);

