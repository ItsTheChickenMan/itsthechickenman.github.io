var locked = false;

function handler(e) {
  if(locked == false){
 	lockMouse(e);
  } else {
	unlockMouse(e);
  }
}

function lockMouse(e) {
  var img = document.createElement("img");
  img.src = "cursor.png";
  img.style = "position: absolute; left: " + e.clientX + "px; up: " + e.clientY + "px;";
  document.getElementById("body").appendChild(img);
  var sty = document.getElementById("sty");
  sty.innerHTML = `html {
	                  cursor: none;
                   }`;
  locked = true;
}

function unlockMouse(e){
	
}
document.addEventListener("click", handler);
//Hi yes I am depression
