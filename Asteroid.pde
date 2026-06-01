class Asteroid {
  PVector pos;
  PVector vel;
  PVector acc;

  float radius;

  boolean crashed;
  boolean escaped;

  Asteroid(float x, float y) {
    pos = new PVector(x, y);
    vel = new PVector(0, 2.6); // 3,0
    acc = new PVector(0, 0);

    radius = 15;

    crashed = false;
    escaped = false;
  }

  void applyGravity(Planet p) {
    if (crashed || escaped) {
      return;
    }

    PVector force = PVector.sub(p.pos, pos);

    float distance = force.mag();
    distance = constrain(distance, 50, 600);

    force.normalize();

    float G = 1.0; //0.8
    float strength = G * p.mass / (distance * distance);

    force.mult(strength);

    acc.add(force);
  }

  void update() {
    if (crashed || escaped) {
      return;
    }

    vel.add(acc);
    pos.add(vel);

    acc.mult(0);
  }

  void checkCrash(Planet p) {
    if (crashed || escaped) {
      return;
    }

    float d = PVector.dist(pos, p.pos);

    if (d < p.radius + radius) {
      crashed = true;
      explosion = new Explosion(pos.x, pos.y);
    }
  }

  void checkEscape() {
    if (crashed || escaped) {
      return;
    }

    if (pos.x < -100 ||
        pos.x > width + 100 ||
        pos.y < -100 ||
        pos.y > height + 100) {

      escaped = true;
    }
  }

  void show() {
    if (crashed) {
      fill(255, 80, 0);
      textSize(24);
      text("CRASH", 20, 145);
      return;
    }

    if (escaped) {
      fill(255);
      textSize(24);
      text("ESCAPED", 20, 145);
      return;
    }

    fill(#EBF016);
    noStroke();
    circle(pos.x, pos.y, radius * 2);
  }

  void reset() {
    explosion = null;
    pos = new PVector(width/4, height/2); //100.250
    vel = new PVector(0, 2.6);
    acc = new PVector(0, 0);

    crashed = false;
    escaped = false;
  }
}
  
  
