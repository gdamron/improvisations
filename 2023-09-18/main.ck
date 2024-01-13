[19, 12, 14, 21, 16, 23, 14, 21] @=> int notes[];
[0, 0, 0, 0, 0, 0, 0, 0] @=> int offsets[];

50 => int base;
0 => int i;
0 => int count;

20::ms => dur onset;
190::ms => dur beat;

TriOsc osc => ADSR adsr => Gain g => dac;
adsr => Delay delay => g;
delay => delay;
adsr => GVerb r => g;

beat * 4 => delay.max;
beat => delay.delay;
0.65 => delay.gain;

0.15 => g.gain;
0.2 => r.dry;

(10::ms, 10::ms, 0.9, 600::ms) => adsr.set;

while(true) {
  Std.mtof(notes[i] + base + offsets[i]) => osc.freq;
  1 => adsr.keyOn;
  onset => now;

  1 => adsr.keyOff;
  beat => now;

  count + 1 => count;

  if (count > 31) {
    -12 => offsets[0];
    -12 => offsets[1];
    12 => offsets[4];
    12 => offsets[5];
    
    if (Math.random2f(0, 1) > 0.95) {
      19 => offsets[5];
    } else {
      12 => offsets[5];
    }
  }


  if (count > 127) {
    0 => count;
    0 => offsets[0];
    0 => offsets[1];
    0 => offsets[4];
    0 => offsets[5];
  }
  
  (i + 1) % notes.cap() => i;
}

