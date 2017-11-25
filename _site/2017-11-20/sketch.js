var noteOn = true;
var lerping = false;
var fromColor;
var toColor;
var backgroundColor;
var step = 0;

function setup() {
    fromColor = color(random(255), random(255), random(255));
    backgroundColor = fromColor;
    createCanvas(windowWidth, windowHeight);
    background(fromColor);
}

function draw() {
    if (noteOn) {
        noteOn = false;
        lerping = true;
        step = 0;
        fromColor = backgroundColor;
        toColor = color(random(255), random(255), random(255));
    }

    if (lerping) {
        backgroundColor = lerpColor(fromColor, toColor, step);
        step += 0.001;

    }

    if (step >= 1) {
        lerping = false;
    }

    background(backgroundColor);
}

window.onNote = function() {
    noteOn = true;
}
