1220 => int BeatDuration;
30000 => int RoundDuration;

Machine.add("bass.ck:"+BeatDuration);
Machine.add("arpegg.ck:"+BeatDuration);
Machine.add("pad.ck:"+BeatDuration+":"+0.2+":"+60);
Machine.add("pad.ck:"+BeatDuration+":"+0.2+":"+60);
Machine.add("pad.ck:"+BeatDuration+":"+0.2+":"+60);
