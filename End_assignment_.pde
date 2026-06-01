Planet planet;
Asteroid asteroid;
Flock flock;
void setup() {
  size(1400,800);
  planet = new Planet(width/2,height/2,80);
  asteroid = new Asteroid(1,1);
  flock = new Flock();
   for (int i = 0; i < 40; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
}

void draw() {
  background(0);
  planet.update();
  
  asteroid.applyGravity(planet);
  asteroid.update();
  asteroid.checkCrash(planet);
  asteroid.checkEscape();
  asteroid.show();
  flock.run();
   planet.show();
}

void keyPressed() {
  planet.handleKey(key);
  
  if (key == 'r' || key == 'R') {
    asteroid.reset();
  }
}

void mousePressed() {
  flock.addBoid(new Boid(mouseX,mouseY));
}
