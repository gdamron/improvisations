[0, 3, 5, 7, 10] @=> int pentatonic[];
[0, 2, 3, 5, 7, 9, 10] @=> int dorian[];

[
    [0,1,2,3],
    [0,1,2,3,4,3,2,1]
] @=> int patterns[][];

pentatonic @=> int degrees[];
patterns[Math.random2(0, patterns.cap() - 1)] @=> int pattern[];
0 => int index;

GVerb r => dac;
BlitSaw osc => Gain g => dac;
g => r;

0.0 => r.dry;
0.8 => r.gain;
0.3 => osc.gain;
.3 => g.gain;

125::ms => dur T;
74 => int base;

while (true) {
    if (index >= pattern.cap()) {
        0 => index;
        patterns[Math.random2(0, patterns.cap() - 1)] @=> pattern;
    }
    pattern[index] => int i;
    Std.mtof(degrees[i] + base) => osc.freq;
    index++;
    T => now;
}
