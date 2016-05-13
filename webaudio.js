var app = Elm.WebAudio.fullscreen();

app.ports.logExternalOut.subscribe(function(value) {
  console.info("logs:", value);
});

app.ports.playSoundOut.subscribe(function(unused) {
  console.info("HERE");
  var audioCtx = new (window.AudioContext || window.webkitAudioContext)();
  var oscillator = audioCtx.createOscillator();

  oscillator.type = 'square';
  oscillator.frequency.value = 3000; // value in hertz
  oscillator.start();
  oscillator.stop(1);

  app.ports.done.send(true);
});

