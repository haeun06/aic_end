Planet planet;
Asteroid asteroid;
Flock flock;
Explosion explosion;
SpaceBackground spaceBg;

void setup() {
  size(1400,800);
  spaceBg = new SpaceBackground(); // initializes the gaussian and perlin bg
  planet = new Planet(width/2,height/2,100);
  asteroid = new Asteroid(300,height/2);
  flock = new Flock();
   for (int i = 0; i < 10; i++) {
    flock.addUfo(new Ufo(width/2,height/2));
  }
}

void draw() {
  background(0);
  spaceBg.show(); // render both gaussian (star) & perlin (nebula gas)
  planet.flagTime += 0.05; // continuously increments time parameter for perlin (flag wave)
  planet.update(); // for msds physics equation (flagepole rotation)
  
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
  float oldForce = planet.force;
  //chekcs if user click flag bounding box (to trigger msds impulse force)
  planet.checkFlagClick(mouseX, mouseY);
  
  if (planet.force == oldForce) {
    //if flag not click -> fallback to spawning a UFO
    flock.addUfo(new Ufo(mouseX, mouseY));
  }
}
