[7, 0, 14, 21, 28, 35, 14, 21] @=> int notes[];
[1.05, 1, 0.95, 0.95, 0.9, 0.95, 1, 1] @=> float durs[];

50 => int base;
0 => int i;
0 => int measure;

Gain mix => LPF lpf => dac;
BlitSaw osc => ADSR adsr => Gain g => mix;
adsr => GVerb r => Gain rgain => mix;

TriOsc lfo1 => blackhole;
120::second => lfo1.period;

TriOsc lfo2 => blackhole;
90::second => lfo2.period;

0.15 => g.gain;
0.0 => r.dry;
0.15 => rgain.gain;

adsr.set(6::ms, 10::ms, 0.8, 600::ms);

fun void play() {
  while(true) {
    Std.mtof(notes[i] + base) => osc.freq;
    adsr.keyOn();
    30::ms => now;

    adsr.keyOff();
    (200 * durs[i])::ms => now;
    
    (i + 1) % notes.cap() => i;

    if (i == 0) {
      1 + measure => measure;
    }

    if (measure % 8 == 0) {
      7 => notes[0];
    } else if (measure % 4 == 0) {
      9 => notes[0];
    }
  }
}

fun void modulate() { 
  while (true) {
    (lfo1.last() + 1.0) / 2.0 * 15000 + 250 => float lfo1Value;
    lfo1Value => lpf.freq;
    
    (lfo2.last() + 1.0) / 2.0 * 10.0 => float lfo2Val;
    lfo2Val => lpf.Q;

    10::ms => now;
  }
}

spork ~ play();
spork ~ modulate();

while (true) {
  1::second => now;
}
