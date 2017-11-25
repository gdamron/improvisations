60 => int base;
7 => int interval;
3 => int count;

if (me.args() > 0) {
    Std.atoi(me.arg(0)) => base;
}

if (me.args() > 1) {
    Std.atoi(me.arg(1)) => interval;
}

if (me.args() > 2) {
    Std.atoi(me.arg(2)) => count;
}

for (0 => int i; i < count; i++) {
    base + i * interval => int freq;
    Machine.add("pad.ck:" + freq);
}
