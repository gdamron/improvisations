// chuck this with other shreds to record to file
// example> chuck foo.ck bar.ck rec (see also rec2.ck)

4::second => dur RING;
Std.atoi(me.arg(0))::ms => dur duration;
(Std.atoi(me.arg(1)) * 3 * 2)::ms => dur countdown;
Std.atoi(me.arg(2)) => int level;
// pull samples from the dac
dac => Gain g => WvOut w => blackhole;

// set the prefix, which will prepended to the filename
// do this if you want the file to appear automatically
// in another directory.  if this isn't set, the file
// should appear in the directory you run chuck from
// with only the date and time.
//"chuck-session" => w.autoPrefix;

// this is the output file name
"level-" + level => w.wavFilename;

// any gain you want for the output
.8 => g.gain;

// temporary workaround to automatically close file on remove-shred
null @=> w;

// infinite time loop...
// ctrl-c will stop it, or modify to desired duration
countdown + duration + RING => now;
