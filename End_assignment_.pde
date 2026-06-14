//CreaTe Y1
//space animation end assignment for aic
//Jasmin Jansen(s3720527) and HaEun Kwack(s3594572)
//Main tab that initaizlies the setup and executes the draw

Planet planet;
Asteroid asteroid;
Flock flock;
Explosion explosion;
SpaceBackground spaceBg;
boolean draggingAsteroid = false;

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

void mousePressed() {
  if (asteroid.isMouseOver(mouseX, mouseY)) {
    draggingAsteroid = true;
  } 
  else if (!planet.handleClick(mouseX, mouseY)) {
    flock.addUfo(new Ufo(mouseX, mouseY));
  }
}

void mouseDragged() {
  if (draggingAsteroid) {
    asteroid.setPosition(mouseX, mouseY);
  }
}

void mouseReleased() {
  draggingAsteroid = false;
}

void keyPressed() {
  planet.handleKey(key);
  
  if (key == 'r' || key == 'R') {
    asteroid.reset();
  }
}
