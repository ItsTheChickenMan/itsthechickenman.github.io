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
  img.id = "swear word XD";
  img.src = "cursor.png";
  img.style = "position: absolute; left: " + e.clientX + "px; top: " + e.clientY + "px;";
  document.getElementById("body").appendChild(img);
  var sty = document.getElementById("sty");
  sty.innerHTML = `html {
	                  cursor: none;
                   }
		   a: hover {
                   	  cursor: none;
                   }`;
  locked = true;
}

function unlockMouse(e){
   var sty = document.getElementById("sty");
   sty.innerHTML = "";
   var img = document.getElementById("swear word XD");
   img.remove();
   locked = false;
}
document.addEventListener("click", handler);
