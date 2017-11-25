// constants
16 => int PULSE_FACTOR;

2 => int LFO_SETTING;
0.1 => float LFO_HZ;

0.001 => float REVERB_DRY;
2000 => int REVERB_SIZE;
9::second => dur REVERB_DECAY;
0.5 => float REVERB_EARLY;
1.0 => float REVERB_TAIL;

14000 => float FILTER_FREQ;
1.0 => float FILTER_Q;
16 => int DELAY_FACTOR;
0.2 => float DELAY_GAIN;

4 => int ADSR_ATTACK_FACTOR;
0 => int ADSR_DECAY_FACTOR;
1.0 => float ADSR_SUSTAIN;
32 => int ADSR_RELEASE_FACTOR;

// parameters
1000::ms => dur T;
0.2 => float START_AMP;
60 => int BASE_NOTE;
if (me.args()) {
    Std.atoi(me.arg(0)) => BASE_NOTE;
}

// ugens
SinOsc vibrato;
SinOsc s, s2, s3;
DelayL d;
ADSR e;
ResonZ f;
GVerb r;
Gain g;

1.0 => g.gain;

[-2, 0, 2] @=> int bottoms[];
[7, 5, 10 ] @=> int mids[];
[10, 12, 14, 14, 17] @=> int tops[];

BASE_NOTE + bottoms[Math.random2(0, bottoms.cap() - 1)] => float freq;
BASE_NOTE + mids[Math.random2(0, mids.cap() - 1)] => float freq2;
BASE_NOTE + tops[Math.random2(0, tops.cap() - 1)] => float freq3;

// lfo
LFO_SETTING => s.sync => s2.sync => s3.sync;
LFO_HZ => vibrato.freq;

// reverb settings
REVERB_DRY => r.dry;
REVERB_SIZE => r.roomsize;
REVERB_DECAY => r.revtime;
REVERB_EARLY => r.early;
REVERB_TAIL => r.tail;

// filter
FILTER_FREQ => f.freq;
FILTER_Q => f.Q;

// patch oscillators
vibrato => s => e;
vibrato => s2 => e;
vibrato => s3 => e;
s => d;
s2 => d;
s3 => d;

0 => s.gain => s2.gain => s3.gain;

// delay
T / DELAY_FACTOR => d.delay;
T => d.max;
DELAY_GAIN => d.gain;

e.set(ADSR_ATTACK_FACTOR::T, ADSR_DECAY_FACTOR::T, ADSR_SUSTAIN, ADSR_RELEASE_FACTOR::second);
START_AMP => s.gain => s2.gain => s3.gain;

e => f => r => g => dac;

while(true)
{
    BASE_NOTE + bottoms[Math.random2(0, bottoms.cap() - 1)]=> freq;
    BASE_NOTE + mids[Math.random2(0, mids.cap() - 1)] => freq2;
    BASE_NOTE + tops[Math.random2(0, tops.cap() - 1)] => freq3;

    Std.mtof(freq) => s.freq;
    Std.mtof(freq2) => s2.freq;
    Std.mtof(freq3) => s3.freq;

    e.keyOn();
    e.attackTime() + e.decayTime() => now;
    e.keyOff();

    Math.min((PULSE_FACTOR::T - e.decayTime() - e.attackTime())/1::ms, e.releaseTime()/1::ms) => float step;
    Math.max(0, step)::ms => now;
}
