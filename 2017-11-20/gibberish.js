const SR = 44100;
const SAMP_MS = SR / 1000;
const SYNTH_COUNT = 3;
const VOICE_COUNT = 3;

const BASE_NOTE = 48;
const INTERVAL = 7;
const BASE_DUR = 16;

const PATTERNS = [
  [-3, -2, 0, 2],
  [7, 5, 10],
  [10, 12, 14, 14, 17],
];

var isSoundInit = false;

window.onmouseup = function () {
  if (isSoundInit) {
    return;
  }

  isSoundInit = true;

  Gibberish.init();
  Gibberish.export(window);
  tune();
};

window.tune = function () {
  var control = {
    sound: sound,
    time: time,
  };

  var synth = PolyMono({
    waveform: "sine",
    attack: SR * 4,
    decay: SR * 12,
    filterType: 3,
    filterMode: 3,
    saturation: 22,
    Q: 0.1,
    resonance: 0.7,
    detune2: 0.0002,
    dtune3: -0.0002,
    antialias: false,
    gain: 0.005,
    maxVoices: VOICE_COUNT * SYNTH_COUNT,
  });

  var reverb = Freeverb({
    roomSize: 1.0,
    damping: 0.2,
    dry: 0,
    wet1: 0.25,
  }).connect();

  synth.connect(reverb);

  seq = Gibberish.Sequencer({
    target: control,
    key: "sound",
    values: [synth],
    timings: [time],
  }).start();
};

function sound(synth) {
  var chord = [];
  for (var i = 0; i < SYNTH_COUNT; i++) {
    var pattern = PATTERNS[i];
    for (var j = 0; j < VOICE_COUNT; j++) {
      var index = Math.floor(Math.random() * pattern.length);
      var degree = BASE_NOTE + INTERVAL * i + pattern[index];
      var freq = midiToFreq(degree);
      chord.push(freq);
    }
  }
  synth.chord(chord);
  onNote();
}

function time() {
  return BASE_DUR * SR;
}

function midiToFreq(midi) {
  return 440 * Math.pow(2, (midi - 69) / 12.0);
}
