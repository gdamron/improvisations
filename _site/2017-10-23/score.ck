
Pattern pattern1;
Pan2 p1 => dac;
-1.0 => p1.pan;
pattern1.connect(p1);

Pattern pattern2;
Pan2 p2 => dac;
1.0 => p2.pan;
pattern2.connect(p2);

pattern1.run();
pattern2.run();

while (true) {
    1::second => now;
};
