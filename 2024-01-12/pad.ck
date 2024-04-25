public class Pad {
  PadConfig config;
  SinOsc vibrato;
  SinOsc s1, s2, s3;
  
  ADSR e => ResonZ f => NRev r => Gain g;
  
  vibrato => s1 => e;
  vibrato => s2 => e;
  vibrato => s3 => e;

  fun void setup(PadConfig c) {
    c @=> config;

    // lfo
    config.lfoMode => s1.sync => s2.sync => s3.sync;
    config.vibratoFreq => vibrato.freq;

    // reverb settings
    config.reverbMix => r.mix;

    // filter
    config.filterFreq => f.freq;
    config.filterQ => f.Q;

    e.set(config.attack, config.decay, config.sustain, config.release);
    config.gain => s1.gain => s2.gain => s3.gain;
  }

  fun void play() {
    g => dac;

    setup(config);

    while(true)
    {
        config.baseNote + config.bottoms[Math.random2(0, config.bottoms.cap() - 1)] => float freq1;
        config.baseNote + config.mids[Math.random2(0, config.mids.cap() - 1)] => float freq2;
        config.baseNote + config.tops[Math.random2(0, config.tops.cap() - 1)] => float freq3;

        Std.mtof(freq1) => s1.freq;
        Std.mtof(freq2) => s2.freq;
        Std.mtof(freq3) => s3.freq;

        e.keyOn();
        e.attackTime() + e.decayTime() => now;
        e.keyOff();

        Math.min((config.pulseFactor::config.beat - e.decayTime() - e.attackTime())/1::ms, e.releaseTime()/1::ms) => float step;
        Math.max(0, step)::ms => now;
    }
  }
}
