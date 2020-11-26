// beats 2 die 2

// main
let pl = createPlaylist(document.getElementById("pl-div"));
let tracks;

/*let tracksRequest = new XMLHttpRequest();

tracksRequest.onreadystatechange = function(){
  if(this.readyState == 4 && this.status == 200){
    let json = JSON.parse(this.responseText);

    tracks = json;
  
    pl.addTracks(tracks);
  }
} 

tracksRequest.open("GET", "tracks/tracks.json", false);
tracksRequest.send();*/

tracks = getTracks();

pl.addTracks(tracks);

// function defs //

// playlist class
function createPlaylist(element){
  return {
    element: element,
    tracks: [],

    addTrack: function(track){
      this.tracks.push(track);

      this.element.appendChild(track.element);
    },

    addTracks: function(tracks){
      let yt = tracks.youtube;
      let fi = tracks.files;
      let lengths = [];

      for(let i = 0; i < yt.length; i++){
        let data = yt[i];

        let te = document.createElement("div");
        let t = createTrack(te, data, "youtube");
        t.formatElement();

        lengths.push(t.length);

        this.addTrack(t);
      }

      for(let i = 0; i < fi.length; i++){
        let data = fi[i];

        let te = document.createElement("div");
        let t = createTrack(te, data, "file");
        t.formatElement();
        
        lengths.push(t.length);

        this.addTrack(t);
      }

      let stats = document.createElement("p");
      let cont = document.createTextNode("Tracks: " + (yt.length + fi.length) + "\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0\u00a0Length: " + addTimes(lengths));

      stats.appendChild(cont);
      stats.style["margin-bottom"] = "0px";

      this.element.insertBefore(stats, this.tracks[0].element) 
    }
  };
}

// base class for track
function createTrack(element, data, type){
  return {
    element: element,
    audioPromise: null,
    audioElement: null,

    title: data.title,
    author: data.author,
    length: data.length,
    identifier: data.title.replace(" ", "-"),
    id: data.id, //although referred to as id, this can mean multiple things depending on this.type
    type: type,

    // youtube api functions
    onPlayerReady: function(){
      let playButton = document.createElement("button");

      playButton.onclick = function(){
        this.startPlayer();
      }.bind(this);

      playButton.style["height"] = '51px';
      playButton.style["width"] = "85px";
      playButton.style["background"] = "lightgray url(css/play.png) no-repeat";
      playButton.style["background-position"] = "center";
      playButton.style["background-size"] = "50px 50px";
      playButton.style["border-width"] = "0px";
      playButton.style["margin-left"] = "5px";
      playButton.style["margin-right"] = "5px";

      let pauseButton = document.createElement("button");

      pauseButton.onclick = function(){
        this.pausePlayer();
      }.bind(this);

      pauseButton.style["height"] = '51px';
      pauseButton.style["width"] = "85px";
      pauseButton.style["background"] = "lightgray url(css/pause.png) no-repeat";
      pauseButton.style["background-position"] = "center";
      pauseButton.style["background-size"] = "50px 50px";
      pauseButton.style["border-width"] = "0px";
      pauseButton.style["margin-left"] = "5px";
      pauseButton.style["margin-right"] = "5px";

      this.element.textContent = this.title + " - " + this.author + " (Audio Player Unavailable)";

      this.element.appendChild(playButton);
      this.element.appendChild(pauseButton);
    },

    startPlayer: function(){
      this.audioElement.playVideo();
    },

    pausePlayer: function(){
      this.audioElement.pauseVideo();
    },

    stopPlayer: function(){
      this.audioElement.stopPlayer();
    },

    // normal functions
    onAudioReturn: function(audio){
      if(typeof audio == "object"){
        this.audioElement = audio;
        this.audioElement.controls = true;
        this.audioElement.style["display"] = "block";

        this.element.textContent = this.title + " - " + this.author;
        this.element.appendChild(this.audioElement);
      } else {
        // if we reach quota or something, we have to load it in an iframe and add controls manually (very dumb and stupid)
        let playerElement = document.createElement("div");
        playerElement.id = this.identifier + "-player";
        playerElement.style["display"] = "none";
        document.body.appendChild(playerElement);

        this.audioElement = new YT.Player(playerElement.id, {
          height: '390',
          width: '640',
          videoId: this.id,
          events: {
            onReady: this.onPlayerReady.bind(this)
          }
        });
      }
    },

    formatElement: function(){
      this.element.class = "track-div";
      this.element.id = this.identifier;
      this.element.style["border"] = "1px solid black";
      this.element.style["margin-bottom"] = "4px";
      this.element.style["width"] = "450px";

      this.element.textContent = "Loading...";

      if(this.type == "youtube"){
        this.audioPromise = createYTAudio(this.id).then(this.onAudioReturn.bind(this));
      } else if(this.type == "file"){
        this.onAudioReturn(createFileAudio(this.id));
      }
    }
  };
}

// utils //
function extend(parent, child){
  let ckeys = Object.keys(child);
	let cvalues = Object.values(child);

	for(let i = 0; i < ckeys.length; i++){
		let key = ckeys[i];
		let value = cvalues[i];
		
		parent[key] = value;
	}
	
	return parent; //it doesn't need to return but it does
}

// adds two "times" together (4m54s) (2h6m34s) (not including days)
function addTimes(times){
  let hours = 0;
  let minutes = 0;
  let seconds = 0;
  
  for(let i = 0; i < times.length; i++){
    let time = [times[i]];

    let h, m, s;

    if(time[0].includes("h")){
      time = time[0].split("h");
      h = parseInt(time[0], 10);
      time.shift();
    }

    if(time[0].includes("m")){
      time = time[0].split("m");
      m = parseInt(time[0], 10);
      time.shift();
    }

    if(time[0].includes("s")){
      time = time[0].split("s");
      s = parseInt(time[0], 10);
      time.shift();
    }

    if(h) hours += h;
    if(m) minutes += m;
    if(s) seconds += s;
  }

  while(seconds >= 60){
    seconds -= 60;
    minutes += 1;
  }

  while(minutes >= 60){
    minutes -= 60;
    hours += 1;
  }

  let final = "";

  if(!hours) hours = 0;
  if(!minutes) minutes = 0;
  if(!seconds) seconds = 0;

  if(hours !== 0){
    final = hours + "h" + minutes + "m" + seconds + "s";
  } else {
    final = minutes + "m" + seconds + "s";
  }

  return final;
}
