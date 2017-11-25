Std.atof(me.arg(1)) / 1000.0 => float songLength; 
Std.atof(me.arg(2)) / 1000.0 => float t;
Std.atof(me.arg(0)) => float pan;
t::second => dur T;

int pattern[me.args() - 3];
for (3 => int i; i < me.args(); i++) {
    Std.atoi(me.arg(i)) => pattern[i-3];
}

Kick k;
k.output => Gain g => Pan2 p => dac;

// set the gain
0.2 => g.gain;

0 => int index;
0.0 => float total;

pan => p.pan;

// countdown
0 => int countdown;

while (countdown < 3) {
    k.hit(Math.random2f(.8,.9));
    countdown++;
    T => now;
}

if (t < 0.35) {
    t * 2 => t;
}

t::second => T;
// time loop
while( total < songLength )
{
    if (pattern[index++] > 0) {
        // set the play position to beginning
        //0 => buf.pos;
        // randomize gain a bit
        //Math.random2f(.8,.9) => buf.gain;
        k.hit(Math.random2f(.8,.9));
    }

    if (index >= pattern.cap()) {
        0 => index;
    }

    total + t * 0.25 => total;
    // advance time
    0.25::T => now;
}

class Kick
{ 
   Impulse i; // the attack 
   i => Gain g1 => Gain g1_fb => g1 => LPF g1_f => Gain BDFreq; // BD pitch envelope 
   i => Gain g2 => Gain g2_fb => g2 => LPF g2_f; // BD amp envelope 
    
   // drum sound oscillator to amp envelope to overdrive to LPF to output 
   BDFreq => TriOsc s => Gain ampenv => TriOsc s_ws => LPF s_f => Gain output; 
   g2_f => ampenv; // amp envelope of the drum sound 
   3 => ampenv.op; // set ampenv a multiplier 
   1 => s_ws.sync; // prepare the SinOsc to be used as a waveshaper for overdrive 
    
   // set default 
   200.0 => BDFreq.gain; // BD initial pitch: 80 hz 
   1.0 - 1.0 / 4000 => g1_fb.gain; // BD pitch decay 
   g1_f.set(1200, 1); // set BD pitch attack 
   1.0 - 1.0 / 1000 => g2_fb.gain; // BD amp decay 
   g2_f.set(200, 1); // set BD amp attack 
   .95 => ampenv.gain; // overdrive gain 
   s_f.set(12000, 1); // set BD lowpass filter 
    
   fun void hit(float v) 
   { 
         v => i.next; 
      } 
   fun void setFreq(float f) 
   { 
         f => BDFreq.gain; 
      } 
   fun void setPitchDecay(float f) 
   { 
         f => g1_fb.gain; 
      } 
   fun void setPitchAttack(float f) 
   { 
         f => g1_f.freq; 
      } 
   fun void setDecay(float f) 
   { 
         f => g2_fb.gain; 
      } 
   fun void setAttack(float f) 
   { 
         f => g2_f.freq; 
      } 
   fun void setDriveGain(float g) 
   { 
         g => ampenv.gain; 
      } 
   fun void setFilter(float f) 
   { 
         f => s_f.freq; 
      } 
} 
