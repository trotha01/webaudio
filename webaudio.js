var app = Elm.WebAudio.fullscreen();

app.ports.logExternalOut.subscribe(function(value) {
  console.info("logs:", value);
});

var audioCtx = new (window.AudioContext || window.webkitAudioContext)();

var playFrequency = function(frequency, gainVal) {
  // create oscillator
  var oscillator = audioCtx.createOscillator();
  oscillator.connect(audioCtx.destination);

  // create gain
  var gain = audioCtx.createGain();
  gain.value = gainVal
  gain.connect(audioCtx.destination);
  oscillator.connect(gain);

  // create analyser
  var analyser = audioCtx.createAnalyser();
  analyser.fftSize = 2048;

  // connect analyser
  gain.connect(analyser);

  // play sound
  // oscillator.type = 'square';
  oscillator.frequency.value = frequency; // value in hertz
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

  }, 500);

  window.setTimeout(function() {
    window.clearInterval(soundDataStream);
  }, 1000);
}

app.ports.playSoundOut.subscribe(function(unused) {
  playFrequency(440, 1);

//   playFrequency(880, 0.5);
//   playFrequency(1760, 0.25);
//   playFrequency(3520, 0.125);

});

