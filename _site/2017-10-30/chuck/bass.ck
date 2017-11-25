3 => int COUNTDOWN_BEATS;
0 => int MAX_OCT;
36 => int BASE_NOTE;
-2 => int START_NOTE;
7 => int TOP_NOTE;
0.35 => float MIN_PULSE;
4 => int PULSE_FACTOR;
2 => int MIN_PULSE_FACTOR;
0.25 => float SHORT_BEAT_WEIGHT;

0.4 => float GAIN_MIN;

440 => float FILTER_MIN_FREQ;
15000 => float FILTER_MAX_FREQ;
1.25 => float FILTER_FREQ_MULTIPLIER;

0 => float REVERB_MIX;
0.1 => float REVERB_GAIN;

-0.4 => float PAN_POSITION;

10::ms => dur ADSR_A;
0::ms => dur ADSR_D;
0.8 => float ADSR_S;
4::second => dur ADSR_R;

4000 => int RING;

Std.atof(me.arg(0)) => float songLength;
Std.atof(me.arg(1)) => float t;

t::ms => dur T;
0 => int step;

float freq;
float freq2;

// scale (in semitones)
[ 0, 0, 0, 8 ] @=> int tonic[];
[ 5, 8 ] @=> int subdominant[];
[ 7, -2 ] @=> int dominant[];

0.0 => float total;

BlitSaw s;
BlitSaw s2;

// connect patch
GVerb r => dac;
LPF f => ADSR e => Pan2 p=> Gain g => dac;
p => r;
1.0 => g.gain;
e.set(ADSR_A, ADSR_D, ADSR_S, ADSR_R);
REVERB_MIX => r.dry;
REVERB_GAIN => r.gain;
s => f;
s2 => f;
PAN_POSITION => p.pan;

FILTER_MIN_FREQ => f.freq;
GAIN_MIN => s.gain => s2.gain;

BASE_NOTE + START_NOTE => freq;
freq + TOP_NOTE => freq2;

Std.mtof(freq) => s.freq;
Std.mtof(freq2) => s2.freq;

// countdown
e.keyOn();
e.attackTime() + e.decayTime() => now;
e.keyOff();
Math.min((COUNTDOWN_BEATS::T - e.decayTime() - e.attackTime())/1::ms, e.releaseTime()/1::ms)::ms => now;

if (t < MIN_PULSE) {
    t * MIN_PULSE_FACTOR => t;
    t::ms => T;
}

0 => int shortBeat;
0 => int lastIndex;
0 => int lastOctave;

while( Math.ceil(total) < songLength )
{
    PULSE_FACTOR => int factor;

    if (f.freq() < FILTER_MAX_FREQ) {
        f.freq() * FILTER_FREQ_MULTIPLIER => f.freq;
    }
    if (step >= 4) {
        0 => step;
    }

    tonic.cap() => int limit;
    tonic @=> int scale[];


    if (step == 1 || step == 2) {
        subdominant.cap() => limit;
        subdominant @=> scale;
    } else if (step == 3) {
        dominant.cap() => limit;
        dominant @=> scale;
    }

    // get note class
    Math.random2(0, MAX_OCT) * 12 => int octave;
    Math.random2(0, limit - 1) => int i;
    if (shortBeat) {
        factor / 4 => factor;
        false => shortBeat;
        lastIndex => i;
        lastOctave => octave;
    } else if (Math.random2f(0, 1) > SHORT_BEAT_WEIGHT) {
        3 * factor / 4 => factor;
        true => shortBeat;
        i => lastIndex;
        octave => lastOctave;
    }

    BASE_NOTE + octave + scale[i] => freq;
    freq + TOP_NOTE => freq2;

    Std.mtof(freq) => s.freq;
    Std.mtof(freq2) => s2.freq;

    e.keyOn();
    e.attackTime() + e.decayTime() => now;
    e.keyOff();
    Math.min((factor::T - e.decayTime() - e.attackTime())/1::ms, e.releaseTime()/1::ms)::ms => now;

    // advance time
    if (!shortBeat) {
        step++;
    }
    total + t * factor => total;
    Math.max(0, (factor::T - e.decayTime() - e.attackTime() - e.releaseTime())/1::ms)::ms => now;
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

