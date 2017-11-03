'use strict';

const sys = require('util');
const exec = require('child_process').exec;
const euclid = require('./euclid');

const CHUCK_PREFIX = './chuck/';

var config = {
    Level: process.env.LEVEL || 1,
    Silent: !!process.env.SILENT,
    BeatDuration: 1000,
    MaxRed: 0,
    MaxBlue: 1,
    RoundDuration: 30000,
    Buttons: 4
}

function run(config) {
    config = euclid.adjustDifficulty(config);
    let RoundDuration = config.RoundDuration;
    let BeatDuration = config.BeatDuration;

    let sequences = [];
    for (let i = 0; i < 4; i++) {
        sequences.push(euclid.generateSequence());
    }
    let cmd = 'chuck';
    let args = ` ${CHUCK_PREFIX}kick.ck:-1:${RoundDuration}:${BeatDuration}:${sequences[0].join(':')} `
        + `${CHUCK_PREFIX}kick.ck:-0.4:${RoundDuration}:${BeatDuration}:${sequences[1].join(':')} `
        + `${CHUCK_PREFIX}kick.ck:0:${RoundDuration}:${BeatDuration}:${sequences[2].join(':')} `
        + `${CHUCK_PREFIX}kick.ck:0.4:${RoundDuration}:${BeatDuration}:${sequences[3].join(':')} `
        + `${CHUCK_PREFIX}kick.ck:1:${RoundDuration}:${BeatDuration}:1:0:0:0 `
        + `${CHUCK_PREFIX}bass.ck:${RoundDuration}:${BeatDuration} `
        + `${CHUCK_PREFIX}arpegg.ck:${RoundDuration}:${BeatDuration} `
        + `${CHUCK_PREFIX}pad.ck:${RoundDuration}:${BeatDuration}:0.1:60 `
        + `${CHUCK_PREFIX}pad.ck:${RoundDuration}:${BeatDuration}:0.025:60 `
        + `${CHUCK_PREFIX}pad.ck:${RoundDuration}:${BeatDuration}:0.05:72`;
    let record = `${CHUCK_PREFIX}rec-auto.ck:${RoundDuration}:${BeatDuration}:${config.Level}`;

    if (config.Silent === false) {
        cmd += args;
    } else {
        cmd += ` --silent ${args} ${record}`;
    }
    console.log(cmd);
    exec(`${cmd}`);
}

run(config);
