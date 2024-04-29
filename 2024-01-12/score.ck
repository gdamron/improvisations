38 => int base;
7 => int interval;
4 => int count;

Drone drone;
Pad pads[count];

if (me.args() > 0) {
    Std.atoi(me.arg(0)) => base;
}

if (me.args() > 1) {
    Std.atoi(me.arg(1)) => interval;
}

if (me.args() > 2) {
    Std.atoi(me.arg(2)) => count;
}

for (0 => int i; i < pads.size() - 1; i++) {
  pads[i] @=> Pad pad;
  base + i * interval => pad.config.baseNote;
  spork ~ pad.play();
}

drone.setup(base);
spork ~ drone.play();

while (true) {
  1::second => now;
}
