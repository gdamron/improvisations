'use strict';

const sys = require('util');
const exec = require('child_process').exec;

const CHUCK_PREFIX = './chuck/';

var config = {
    BeatDuration: 1220,
    RoundDuration: 30000,
}

function run(config) {
    let RoundDuration = config.RoundDuration;
    let BeatDuration = config.BeatDuration;

    let cmd = 'chuck';
    let args = ` ${CHUCK_PREFIX}bass.ck:${RoundDuration}:${BeatDuration} `
        + `${CHUCK_PREFIX}arpegg.ck:${RoundDuration}:${BeatDuration} `
        + `${CHUCK_PREFIX}pad.ck:${RoundDuration}:${BeatDuration}:0.2:60 `
        + `${CHUCK_PREFIX}pad.ck:${RoundDuration}:${BeatDuration}:0.15:60 `
        + `${CHUCK_PREFIX}pad.ck:${RoundDuration}:${BeatDuration}:0.15:60`;

    cmd += args;
    console.log("starting chuck");
    exec(`${cmd}`);
}

run(config);
