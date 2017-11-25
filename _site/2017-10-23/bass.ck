[0, 2, 7, 9, 12, 14] @=> int degrees[];
[1, 2] @=> int durations[];

BlitSaw osc => Gain g => dac;
2000::ms => dur T;
36 => int base;
0.5 => g.gain;

while (true) {
    Math.random2(0, degrees.cap() - 1) => int i;
    Std.mtof(degrees[i] + base) => osc.freq;

    Math.random2(0, durations.cap() - 1) => i;
    durations[i] * T => now;
}
