var noteOn = false;
var tNoise = 0;
var currentNoise = 0;

var bgColor;

const rad = 16;
const xyIncr = 0.05;
const tIncr = 0.0005;
const circleDiv = 4;
const flowMag = 1;
const grainCnt = 1024;

var rows = 0;
var cols = 0;
var grains = [];

function setup() {
    createCanvas(windowWidth, windowHeight);
    colorMode(HSB, 255, 255, 255, 255);
    rows = floor(height / rad);
    cols = floor(width / rad);
    bgColor = color(random(255), random(255), random(255));
    for (var i = 0; i < grainCnt; i++) {
        grains.push(new Grain(bgColor));
    }
    background(bgColor);
}

function draw() {
    tNoise += tIncr;
    for (var i = 0; i < grains.length; i++) {
        const grain = grains[i];
        const row = floor(grain.pos.x / rad);
        const col = floor(grain.pos.y / rad);
        currentNoise = noise(col * xyIncr, row * xyIncr, tNoise);
        const angle = currentNoise * TWO_PI * circleDiv;
        var vec = p5.Vector.fromAngle(angle);
        vec.setMag(flowMag);

        grain.apply(vec);
        grain.update();
        grain.show();
    }
}

window.getNoise = function() {
    return currentNoise;
}

window.onNote = function() {
    noteOn = true;
}
