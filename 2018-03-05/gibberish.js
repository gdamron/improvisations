const SR = 44100;
const SAMP_MS = SR / 1000;
const SYNTH_COUNT = 3;
const VOICE_COUNT = 2;

const BASE_NOTE = 36;
const INTERVAL = 7;
const BASE_DUR = 8;

const DURS = [0.125, 0.25, 0.5]

const PATTERN = [
    0, 7, 14, 21, 28, 35, 42
];

const WAVE = ['sine', 'saw', 'triangle']

window.onload = function() {
    Gibberish.init();
    Gibberish.export(window);
    tune();
}

window.tune = function() {
    var control = {
        sound: sound,
        time: time
    };
    
    var reverb = Freeverb({
        roomSize: 1.0,
        damping: 0.01,
        dry: 0,
        wet1: 0.6,
    }).connect();

    var synths = [];
    for (let i = 0; i < SYNTH_COUNT; i++) {
        const wave = Math.floor(Math.random() * WAVE.length);
        const synth = createSynth(wave);
        synth.connect(reverb);
        synths.push(synth);
    }

    seq = Gibberish.Sequencer({
        target: control,
        key: 'sound',
        values: synths,
        timings: [time],
    }).start();
};

function createSynth(wave) {
    return PolySynth({
        waveform: WAVE[wave],
        attack:SR/8,
        decay:SR * BASE_DUR,
        filterType: 1,
        filterMode: 0,
        cutoff: 0.01,
        filterMult: 9,
        saturation: 22,
        Q: 0.6,
        resonance: 9.85,
        antialias: true,
        gain: 0.5,
        maxVoices: VOICE_COUNT
    });
}

function sound(synth) {
    var freq;
    while(!freq || synth.voices.find(function(f) { return f.frequency === freq })) {
        var index = Math.floor(Math.random() * PATTERN.length);
        var degree = BASE_NOTE + PATTERN[index];
        freq = midiToFreq(degree);
    }

    synth.note(freq);

}

function time() {
    var index = Math.floor(Math.random() * DURS.length);
    var multiplier = DURS[index]
    return BASE_DUR * multiplier * SR;
}

function midiToFreq(midi) {
    return 440 * Math.pow(2, (midi - 69)/12.0);
}
