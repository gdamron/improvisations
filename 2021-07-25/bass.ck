24 => int BASE_NOTE;
4 => int PULSE_FACTOR;
0.2 => float ON_CHANCE;
0.4 => float GAIN_MIN;

220 => float FILTER_MIN_FREQ;
15000 => float FILTER_MAX_FREQ;
1.25 => float FILTER_FREQ_MULTIPLIER;

10::ms => dur ADSR_A;
0::ms => dur ADSR_D;
0.8 => float ADSR_S;
16::second => dur ADSR_R;

Std.atof(me.arg(0)) => float t;

t::ms => dur T;
0 => int step;

float freq;
float freq2;

// scale (in semitones)
[ 0, 8, 8 ] @=> int notes[];

0.0 => float total;

BlitSaw s;

// connect patch
LPF f => ADSR e => Gain g => dac;
1.0 => g.gain;
e.set(ADSR_A, ADSR_D, ADSR_S, ADSR_R);
s => f;

FILTER_MIN_FREQ => f.freq;
GAIN_MIN => s.gain;

while( true )
{
    PULSE_FACTOR => int factor;

    // roll the dice on whether to play a note
    if (Math.randomf() > ON_CHANCE) {
        factor::T => now;
        continue;
    }

    if (f.freq() < FILTER_MAX_FREQ) {
        f.freq() * FILTER_FREQ_MULTIPLIER => f.freq;
    }
    if (step >= 4) {
        0 => step;
    }

    // get note class
    Math.random2(0, notes.cap() - 1) => int i;
    BASE_NOTE + notes[i] => freq;
    Std.mtof(freq) => s.freq;

    e.keyOn();
    e.attackTime() + e.decayTime() => now;
    e.keyOff();
    Math.min((factor::T - e.decayTime() - e.attackTime())/1::ms, e.releaseTime()/1::ms)::ms => now;

    // advance time
    total + t * factor => total;
    Math.max(0, (factor::T - e.decayTime() - e.attackTime() - e.releaseTime())/1::ms)::ms => now;
}

