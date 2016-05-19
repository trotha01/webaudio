var app = Elm.Visualizer.fullscreen();

app.ports.logExternalOut.subscribe(function(value) {
  console.info("logs:", value);
});

var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

var playFrequency = function(oscillator, gainVal) {

  // create gain
  var gain = audioCtx.createGain();
  gain.value = gainVal
  gain.connect(audioCtx.destination);
  oscillator.connect(gain);

  // create analyser
  var analyser = audioCtx.createAnalyser();
  // analyser.fftSize = 2048;
  analyser.fftSize = 1024;

  // connect analyser
  gain.connect(analyser);

  oscillator.start();
  oscillator.stop(audioCtx.currentTime + 1);

  // send sound data
  var soundDataStream = window.setInterval(function() {

    var bufferLength = analyser.frequencyBinCount;
    var dataArray = new Uint8Array(bufferLength);
    analyser.getByteTimeDomainData(dataArray);

    // we convert since Uint8Array is actually an object
    var array = [].slice.call(dataArray)
    app.ports.soundData.send(array);
    console.log("sent");

  }, 10);

  window.setTimeout(function() {
    window.clearInterval(soundDataStream);
  }, 1000);
}

app.ports.playOscillator.subscribe(function(settings) {
  // create oscillator
  var oscillator = audioCtx.createOscillator();
  oscillator.connect(audioCtx.destination);

  // play sound
  oscillator.type = settings.shape;
  oscillator.frequency.value = settings.frequency; // value in hertz
  oscillator.detune.value = settings.detune;

  console.log("here");
  playFrequency(oscillator, 1);
});

