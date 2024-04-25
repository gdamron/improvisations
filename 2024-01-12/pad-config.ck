public class PadConfig {
  // time
  1000::ms => dur beat;
  16 => int pulseFactor;

  // notes
  0.2 => float gain;
  60 => int baseNote;
  4::beat => dur attack;
  0::beat => dur decay;
  1.0 => float sustain;
  32::beat => dur release;
  [-2, 0, 2] @=> int bottoms[];
  [7, 5, 10 ] @=> int mids[];
  [10, 12, 14, 14, 17] @=> int tops[];
  
  // lfo
  0.1 => float vibratoFreq;
  2 => int lfoMode;

  // fx
  0.5 => float reverbMix;
  14000 => float filterFreq;
  1.0 => float filterQ;

}
