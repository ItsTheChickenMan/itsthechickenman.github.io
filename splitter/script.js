// main
let input = document.getElementById("content-input");
let splitButton = document.getElementById("content-split-button");
let nextButton = document.getElementById("next-segment-button");
let prevButton = document.getElementById("prev-segment-button");
let copyButton = document.getElementById("copy-segment-button");
let segmentContent = document.getElementById("segment-box-div");
let segmentCount = document.getElementById("segment-count-p");

let segments = [];
let segment = 0;

splitButtonClick();

// bind event listeners
splitButton.addEventListener("click", splitButtonClick);
nextButton.addEventListener("click", nextButtonClick);
prevButton.addEventListener("click", prevButtonClick);
copyButton.addEventListener("click", copyButtonClick);

// event listeners
function splitButtonClick(e){
  segments = split(input.value, 2000);
  segment = 0;

  segmentCount.innerHTML = "Segments: " + segments.length;

  displaySegment(segment);
}

function nextButtonClick(e){
  if(segment < segments.length-1) segment++;

  displaySegment(segment);
}

function prevButtonClick(e){
  if(segment > 0) segment --;

  displaySegment(segment);
}

function copyButtonClick(e){
  if (document.selection) {
    var range = document.body.createTextRange();
    range.moveToElementText(segmentContent);
    range.select().createTextRange();
    document.execCommand("copy");

    document.selection.empty();
  } else if (window.getSelection) {
    var range = document.createRange();
    range.selectNode(segmentContent);
    window.getSelection().addRange(range);
    document.execCommand("copy");

    window.getSelection().removeAllRanges();
  }
}

// utils
function split(text, amount){
  let segs = [];
  let seg = 0;

  segs[seg] = "";

  for(let i = 0; i < text.length; i++){
    segs[seg] += text[i];

    if(i % 2000 == 0 && i !== 0){
      seg++;
      segs[seg] = "";
    }
  }

  return segs;
}

function displaySegment(index){
  segmentContent.innerHTML = segments[index];
}