// constants
0.4 => float GAIN_MAX;
0.05 => float GAIN_INCR;
0.1 => float GAIN_BIAS;

16 => int PULSE_FACTOR;
350 => int MIN_PULSE;
2 => int MIN_PULSE_FACTOR;

2 => int LFO_SETTING;
0.1 => float LFO_HZ;

0.001 => float REVERB_DRY;
3000 => int REVERB_SIZE;
10::second => dur REVERB_DECAY;
0.5 => float REVERB_EARLY;
1.0 => float REVERB_TAIL;

14000 => float FILTER_FREQ;
1.0 => float FILTER_Q;
16 => int DELAY_FACTOR;
0.4 => float DELAY_GAIN;

500 => int ADSR_PULSE_THRESH;
4 => int ADSR_ATTACK_FACTOR;
0 => int ADSR_DECAY_FACTOR;
0.8 => float ADSR_SUSTAIN;
32 => int ADSR_RELEASE_FACTOR;

4000 => int RING;

// parameters
Std.atof(me.arg(0)) => float t;
Std.atof(me.arg(1)) => float START_AMP;
Std.atoi(me.arg(2)) => int BASE_NOTE;

// ugens
SinOsc vibrato;
SinOsc s;
SinOsc s2;
SinOsc s3;
DelayL d;
ADSR e => ResonZ f => Pan2 p => GVerb r => Gain g => dac;
1.0 => g.gain;

[-5, 0, 3] @=> int bottoms[];
[7, 3, 10 ] @=> int mids[];
[12, 15, 19, 22] @=> int tops[];

BASE_NOTE + bottoms[Math.random2(0, bottoms.cap() - 1)] => float freq;
BASE_NOTE + mids[Math.random2(0, mids.cap() - 1)] => float freq2;
BASE_NOTE + tops[Math.random2(0, tops.cap() - 1)] => float freq3;

// time
t::ms => dur T;
// lfo
LFO_SETTING => s.sync => s2.sync => s3.sync;
LFO_HZ => vibrato.freq;

// pan
Math.random2f(-1, 1) => p.pan;

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

Std.mtof(freq) => s.freq;
Std.mtof(freq2) => s2.freq;
Std.mtof(freq3) => s3.freq;

if (t < MIN_PULSE) {
    t * 2 => t;
}

t::ms => T;

// delay
T / DELAY_FACTOR => d.delay;
T => d.max;
DELAY_GAIN => d.gain;

(ADSR_ATTACK_FACTOR::T + ADSR_DECAY_FACTOR::T + ADSR_RELEASE_FACTOR::second) / 1::ms => float measure;
e.set(ADSR_ATTACK_FACTOR::T, ADSR_DECAY_FACTOR::T, ADSR_SUSTAIN, ADSR_RELEASE_FACTOR::second);
(e.attackTime() + e.releaseTime() + e.decayTime()) / 1::ms => float millis;
START_AMP + GAIN_BIAS => s.gain => s2.gain => s3.gain;
while( true )
{
    if (s.gain() < GAIN_MAX) {
        s.gain() + GAIN_INCR => s.gain => s2.gain => s3.gain;
    }
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

0 => int decay;
1.0 / RING => float decayStep;
while (decay < RING) {
    if (g.gain() > 0) {
        Math.max(0.0, g.gain() - decayStep) => g.gain;
    }
    decay++;
    1::ms => now;

    if (g.gain() <= 0) {
        break;
    }
}
