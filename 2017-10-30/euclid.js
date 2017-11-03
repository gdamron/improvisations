'use strict';

const PHRASE_LENGTH = 16;
const M_MIN = 8;
const M_MAX = 16;
const K_MIN_DENOM = 4;
const K_MAX_DENOM = 2;
const MAX_BUTTONS = 4;

const DIFFICULTY_TIME_INTERVAL = 12;
const DIFFICULTY_RED_INTERVAL = 4;
const DIFFICULTY_BLUE_INTERVAL = 8;
const DIFFICULTY_ROUND_INTERVAL = 1000;
const DIFFICULTY_ROUND_THRESHOLD = 15;

const MIN_BLUE = 1;
const MAX_BLUE = 4;
const MAX_RED = 4;
const MIN_DUR = 250;

function adjustDifficulty(config) {
    let level = config.Level;
    let buttonHandicap = 1; //MAX_BUTTONS / config.Buttons;
    config.BeatDuration = config.BeatDuration / buttonHandicap - (level - 1) * DIFFICULTY_TIME_INTERVAL / buttonHandicap;
    if (config.BeatDuration < MIN_DUR) {
        config.BeatDuration = MIN_DUR;
    }

    config.MaxBlue = MIN_BLUE + Math.floor(level * buttonHandicap / DIFFICULTY_BLUE_INTERVAL);
    if (config.MaxBlue > MAX_BLUE) {
        conifg.MaxBlue = MAX_BLUE;
    }
    config.MaxRed = Math.floor(level * buttonHandicap / DIFFICULTY_RED_INTERVAL);
    if (config.MaxRed > MAX_RED) {
        config.MaxRed = MAX_RED;
    }

    if (level > DIFFICULTY_ROUND_THRESHOLD) {
        config.RoundDuration = config.RoundDuration + (level - DIFFICULTY_ROUND_THRESHOLD) * DIFFICULTY_ROUND_INTERVAL;
    }

    let measure = config.BeatDuration * PHRASE_LENGTH;
    let measures = Math.floor(config.RoundDuration / measure);
    let realDuration = measure * measures;
    while (realDuration < config.RoundDuration) {
        realDuration += measure;
    }

    config.RoundDuration = realDuration;

    console.log(`Set difficulty: beat=${config.BeatDuration}, blues=${config.MaxBlue}, red=${config.MaxRed}, dur=${config.RoundDuration}`);

    return config;
}

function generateSequence() {
    let m = Math.round(Math.random() * (M_MAX - M_MIN) + M_MIN);
    let kMin = Math.round(m / K_MIN_DENOM);
    let kMax = Math.floor(m / K_MAX_DENOM - 1);
    let k = Math.round(Math.random() * (kMax - kMin) + kMin);
    let pattern = euclidRhythm(k, m);
    let shuffled = randomizedPattern(pattern);
    console.log(`${shuffled}`);
    return shuffled;
}

function euclidRhythm(k, m) {
    let groups = [];
    for (let i = 0; i < m; i++) {
            groups.push([Number(i < k)]);
        };

    let last = groups.length - 1;

    while(last) {
            let firstGroup = groups[0];
            let lastGroup = groups[last];
            let j = last;
            let start = 0;

            while (start < last && firstGroup.equals(groups[start])) {
                        start++;
                    }
            if (start === last) {
                        break;
                    }

            while (j && lastGroup.equals(groups[j])) {
                        j--;
                    }
            if (j === 0) {
                        break;
                    }

            let count = Math.min(start, last - j);
            groups = groups
                .slice(0, count)
                .map(function(group, i) { return group.concat(groups[last - i]); })
                .concat(groups.slice(count, -count));
            last = groups.length - 1;
        }

    return [].concat(groups.concat.apply([], groups));
}

function randomizedPattern(euclid) {
    let randomIndex = Math.random() * euclid.length;
    randomIndex = Math.floor(randomIndex);

    let pattern = [];
    for (let i = 0; i < euclid.length; i++) {
            if (randomIndex >= euclid.length) {
                        randomIndex = 0;
                    }
            pattern.push(euclid[randomIndex++]);
        }
    return pattern;
}

Array.prototype.equals = function(arr) {
    if (!arr) {
            return false;
        };

    if (this.length !== arr.length) {
            return false;
        };

    return this.every(function(val,i) { return val === arr[i]  });
};

module.exports = {
    adjustDifficulty: adjustDifficulty,
    generateSequence: generateSequence
}
