// thanks to Josh Stovall on SO for this (https://stackoverflow.com/a/64117539)

// YouTube video ID
function createYTAudio(id){
  let audioElement = document.createElement("audio");

  // Fetch video info (using a proxy if avoid CORS errors)
  return promiseTimeout(4000, fetch('https://cors-anywhere.herokuapp.com/' + "https://www.youtube.com/get_video_info?video_id=" + id)).then(response => {
    if (response.ok) {
      return response.text().then(ytData => {
        // parse response to find audio info
        ytData = parse_str(ytData);
        let playerResponse = JSON.parse(ytData.player_response);

        if(playerResponse.playabilityStatus.status == "UNPLAYABLE"){
          return 1000;
        }

        let getAdaptiveFormats = playerResponse.streamingData.adaptiveFormats;
        let findAudioInfo = getAdaptiveFormats.findIndex(obj => obj.audioQuality);
        
        // get the URL for the audio file
        let audioURL = getAdaptiveFormats[findAudioInfo].url;
        
        // update the <audio> element src
        audioElement.src = audioURL;

        return audioElement;
      });
    } else {
      return response.status;
    }
  })
  .catch(err => {
    console.log(err);
    return err;
  });
}

function createFileAudio(path){
  let audioElement = document.createElement("audio");

  audioElement.src = path;

  return audioElement;
}

function parse_str(str) {
  return str.split('&').reduce(function(params, param) {
    let paramSplit = param.split('=').map(function(value) {
      return decodeURIComponent(value.replace('+', ' '));
    });
    params[paramSplit[0]] = paramSplit[1];
    return params;
  }, {});
}

function promiseTimeout(timeout, promise){
  let timeoutPromise = new Promise((resolve, reject) => {
    let tm = window.setTimeout(() => {
      reject("Promise timed out in " + timeout + "ms");
    }, timeout);
  });

  return Promise.race([timeoutPromise, promise]);
}
