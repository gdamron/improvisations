350 => float MIN_PULSE;
0 => int MAX_OCT;
48 => int BASE_NOTE;
7 => int TOP_NOTE;
0.25 => float BEAT_FRACT;
24 => float SWEEP_RATE;
4200.0 => float MAX_LPF;
210.0 => float MIN_LPF;

Std.atof(me.arg(0)) => float t;

t::ms => dur T;
0 => int step;
0 => int patternIndex;

float freq;

// scale (in semitones)
[
    [0, 3, 10, 12, 0, 3, 10, 12],
    [0, 3, 12, 10, 0, 3, 10, 8],
    [3, 7, 10, 12, 14, 12, 10, 10],
    [8, 8, 5, 8, 8, 8, 5, 8],
    [0, 3, 7, 5, 3, 7, 5, 3],
    [0, 3, 3, 0, 3, 3, 0, 3]
] @=> int tonic[][];

0.0 => float total;

BlitSaw s;
DelayL d;
// connect patch
//GVerb r => dac;
JCRev r => dac;
LPF f => Pan2 p => dac;
p => r;
0.4 => p.pan;
1::second => d.max;
0.1 => d.gain;
T => d.delay;
d => f;
s => d;
s => f;
// 0 => r.dry;
// 0.35 => r.gain;
0.4 => r.mix;
MIN_LPF => f.freq;
BASE_NOTE - 2 => freq;
Std.mtof(freq) => s.freq;
0.2 => s.gain;
true => int isOpening;

if (t < MIN_PULSE) {
    t * 2 => t;
    t::ms => T;
}

while( true )
{
    if (isOpening == true) {
        f.freq() + SWEEP_RATE => f.freq;
        if (f.freq() > MAX_LPF) {
            false => isOpening;
        } 
    } else {
        f.freq() - SWEEP_RATE => f.freq;
        if (f.freq() < MIN_LPF) {
            true => isOpening;
        }
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
