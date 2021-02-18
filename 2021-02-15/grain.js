class Grain {
    constructor(col) {
        this.pos = createVector(random(width), random(height));
        this.prev = createVector(this.pos.x, this.pos.y);
        this.vel = createVector(0, 0);
        this.acc = createVector(0, 0);
        this.maxSpeed = Math.random() * 3 + 2;
        this.color = color(255 - col.levels[0], 255 - col.levels[1], 255 - col.levels[2], 5);
    }

    update() {
        this.vel.add(this.acc);
        this.vel.limit(this.maxSpeed);
        this.pos.add(this.vel);
        this.acc.mult(0);
        this.edges();
    }

    apply(force) {
        this.acc.add(force);
    }

    show() {
        stroke(this.color);
        strokeWeight(1);
        line(this.pos.x, this.pos.y, this.prev.x, this.prev.y);
        this.updatePrev();
    }

    edges() {
        const x = this.pos.x;
        const y = this.pos.y;
        if (x < 0) {
            this.pos.x = width;
            this.updatePrev();
        }

        if (x > width) {
            this.pos.x = 0;
            this.updatePrev();
        }

        if (y < 0) {
            this.pos.y = height;
            this.updatePrev();
        }

        if (y > height) {
            this.pos.y = 0;
            this.updatePrev();
        }
    }

    updatePrev() {
        this.prev.x = this.pos.x;
        this.prev.y = this.pos.y;
    }
}
