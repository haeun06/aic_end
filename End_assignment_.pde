Planet planet;
Asteroid asteroid;
Flock flock;
Explosion explosion;
SpaceBackground spaceBg;

void setup() {
  size(1400,800);
  spaceBg = new SpaceBackground();
  planet = new Planet(width/2,height/2,100);
  asteroid = new Asteroid(300,height/2);
  flock = new Flock();
   for (int i = 0; i < 10; i++) {
    flock.addUfo(new Ufo(width/2,height/2));
  }
}

void draw() {
  background(0);
  spaceBg.show();
  planet.update();
  
  asteroid.applyGravity(planet);
  asteroid.update();
  asteroid.checkCrash(planet);
  asteroid.checkEscape();
  asteroid.show();
  flock.run();
   planet.show();
   
   if (explosion != null) {
  explosion.update();
  explosion.show();
}
}

void keyPressed() {
  planet.handleKey(key);
  
  if (key == 'r' || key == 'R') {
    asteroid.reset();
  }
}

void mousePressed() {
  flock.addUfo(new Ufo(mouseX,mouseY));
}
