[0, 2, 5, 7, 9, 12, 14] @=> int pentatonic[];
[0, 2, 4, 5, 7, 9, 11, 12, 14] @=> int dorian[];

int degrees[];

if (Math.random2(0, 1) == 0) {
    pentatonic @=> degrees;
} else {
    dorian @=> degrees;
}
[0.5, 1, 0.25, 2] @=> float durations[];

BlitSaw osc => Gain g => dac;
GVerb r => g;
osc => r;

0.0 => r.dry;
0.2 => r.gain;
.2 => g.gain;

500::ms => dur T;
60 => int base;

while (true) {
    Math.random2(0, degrees.cap() - 1) => int i;
    Std.mtof(degrees[i] + base) => osc.freq;

    Math.random2(0, durations.cap() - 1) => i;
    durations[i] * T => now;
}
