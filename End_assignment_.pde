// End assignment AIC Jasmin Jansen(s3720527) and Ha Eun Kwack

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
  spaceBg.update(); // render both gaussian (star) & perlin (nebula gas)
  planet.update();// for msds physics equation (flagepole rotation)
  asteroid.update(planet);
    flock.run();
 
   
}

void keyPressed() {
  planet.handleKey(key);
  
  if (key == 'r' || key == 'R') {
    asteroid.reset();
  }
}

void mousePressed() { //chekcs if user click flag bounding box (to trigger msds impulse force)
  boolean flagClicked = planet.flag.checkClick(planet.pos, planet.radius, mouseX, mouseY);
  
  if (!flagClicked) { //if flag not click -> fallback to spawning a UFO
    flock.addUfo(new Ufo(mouseX, mouseY));
  }
}
