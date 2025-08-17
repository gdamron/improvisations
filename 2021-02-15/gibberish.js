const SR = 44100;
const SYNTH_COUNT = Math.floor(Math.random() * 2) + 1;
const VOICE_COUNT = SYNTH_COUNT * 3;

const BASE_NOTE = 42;
const BASE_DUR = Math.random() * 0.1 + 0.1;

const PATTERN_GEN_INTERVAL = 20000;
const MIN_WEIGHT = 1;
const MAX_WEIGHT = 5;
const BASE_PATTERN = [-BASE_NOTE, -4, -2, 0, 3, 5, 7, 10, 12, 14, 15, 17, 19];

var DURS = generateDurs();
var PATTERN = [];

var isSoundInit = false;

window.onmouseup = function () {
  if (isSoundInit) {
    return;
  }

  isSoundInit = true;

  Gibberish.init();
  Gibberish.export(window);
  generatePatternPeriodically();
  tune();
};

window.tune = function () {
  var control = {
    sound: sound,
    time: time,
  };

  const params = generateSynthParams();
  console.log(params);

  var reverb = Freeverb({
    roomSize: 1.0,
    damping: params.damping,
    dry: 0.01,
    wet1: 0.6,
  }).connect();

  var synths = [];

  const baseGain = 1.0 / VOICE_COUNT;
  for (let i = 0; i < SYNTH_COUNT; i++) {
    const synth = createSynth(
      params.waveform,
      params.gain * baseGain,
      params.attack,
    );
    synth.connect(reverb);
    synths.push(synth);
  }

  seq = Gibberish.Sequencer({
    target: control,
    key: "sound",
    values: synths,
    timings: [time],
  }).start();
};

function createSynth(wave, gain, attack) {
  return PolySynth({
    waveform: wave,
    gain: gain,
    maxVoices: VOICE_COUNT,
    attack: attack,
  });
}

function sound(synth) {
  const notes = generateNotes();
  synth.chord(notes);
}

function time() {
  var index = Math.floor(window.getNoise() * DURS.length);
  var multiplier = DURS[index];
  return BASE_DUR * multiplier * SR;
}

function midiToFreq(midi) {
  return 440 * Math.pow(2, (midi - 69) / 12.0);
}

function generateSynthParams() {
  const waves = ["sine", "triangle", "pwm", "square"];
  const gains = [1.0, 0.8, 0.2, 0.1];
  const dampings = [0.6, 0.2, 0.01, 0.01];
  const attacks = [256, 128, 64, 64];

  const index = Math.floor(Math.random() * waves.length);
  const waveform = waves[index];
  const gain = gains[index];
  const damping = dampings[index];
  const attack = attacks[index];

  return {
    waveform,
    gain,
    damping,
    attack,
  };
}

function generatePattern() {
  let notes = [];

  for (const note of BASE_PATTERN) {
    let cnt = Math.floor(Math.random() * MAX_WEIGHT) + MIN_WEIGHT;
    while (cnt > 0) {
      notes.push(note);
      cnt--;
    }
  }

  return notes;
}

function generatePatternPeriodically() {
  PATTERN = generatePattern();
  setTimeout(generatePatternPeriodically, PATTERN_GEN_INTERVAL);
}

function generateDurs() {
  return [0.5, 1, 2];
}

function generateNotes() {
  const r = Math.floor(random(PATTERN.length));
  const n = Math.floor(window.getNoise() * PATTERN.length);
  var index = Math.floor(0.45 * r + 0.55 * n);
  var degree = BASE_NOTE + PATTERN[index];
  var freq = midiToFreq(degree);

  let notes = [freq, freq * 1.5, freq * 2];

  if (Math.random() > 0.75) {
    notes = notes.splice(1);
  }

  if (Math.random() > 0.4) {
    notes = notes.splice(0);
  }

  return notes;
}
