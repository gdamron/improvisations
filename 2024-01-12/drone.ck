public class Drone {

  SinOsc osc => Gain g;
  0.1 => g.gain;

  Math.random2(1,3) => int octave;
  55.0 * octave => osc.freq;
  Math.random2f(0.0,1.0) => osc.phase;

  fun setup(int note) {
    Std.mtof(note) => osc.freq;
  }

  fun void play() {
    g => dac;
    while (true) {
      1::second => now;
    }
  }
}
