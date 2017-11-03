350 => float MIN_PULSE;
0 => int MAX_OCT;
36 => int BASE_NOTE;
7 => int TOP_NOTE;
0.25 => float BEAT_FRACT;
30 => float SWEEP_RATE;

Std.atof(me.arg(0)) => float songLength;
Std.atof(me.arg(1)) => float t;

t::ms => dur T;
0 => int step;
0 => int patternIndex;

float freq;

// scale (in semitones)
[
    [ 0, 12, 15, 12, 15, 12, 15, 12 ],
    [ 0, 12, 15, 12, 15, 12, 15, 12 ],
    [ 0, 15, 19, 15, 19, 15, 19, 15 ],
    [ 0, 12, 15, 19, 22, 20, 19, 15 ],
    [ 0, 12, 15, 19, 22, 20, 19, 15 ],
    [ 0, 12, 15, 19, 20, 19, 15, 10 ],
    [ 20, 19, 15, 12, 20, 19, 15, 12 ],
    [ 20, 19, 15, 12, 0, 12, 15, 19 ],
    [ 22, 20, 19, 15, 12, 10, 8, 7 ]
] @=> int tonic[][];

0.0 => float total;

BlitSaw s;
DelayL d;
// connect patch
GVerb r => dac;
LPF f => Pan2 p => dac;
p => r;
0.4 => p.pan;
1::second => d.max;
0.1 => d.gain;
T => d.delay;
d => f;
s => d;
s => f;
0 => r.dry;
0.35 => r.gain;
420 => f.freq;
BASE_NOTE - 2 => freq;
Std.mtof(freq) => s.freq;
0.3 => s.gain;

// countdown
0 => int countdown;
while (countdown < 3) {
    countdown++;
    T => now;
}

if (t < MIN_PULSE) {
    t * 2 => t;
    t::ms => T;
}

while( total < songLength )
{
    if (f.freq() < 15000) {
        f.freq() + SWEEP_RATE => f.freq;
    }

    tonic[patternIndex].cap() => int limit;

    if (step >= limit) {
        0 => step;
        Math.random2(0, tonic.cap() - 1) => patternIndex;
    }

    tonic[patternIndex] @=> int scale[];
    
    BASE_NOTE + scale[step] => freq;
    Std.mtof(freq) => s.freq;

    step++;

    // advance time
    total + t * BEAT_FRACT => total;
    BEAT_FRACT::T => now;
}

0 => s.freq;

4::second => now;
