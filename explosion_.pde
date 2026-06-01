// Space animation by jasmin Jansen and Ha eun
// Creates explosion when the asteroid crashes onto the planet 
// explodes into multiple particle object that spreads out 

class Explosion {
  float hu;
  ArrayList<Particle> particles; // list of particles after explosion
  Explosion(float x, float y) {
    
    hu = (40);
    particles = new ArrayList<Particle>();
  
  
   for (int i = 0; i < 100; i++) {
    particles.add(new Particle(x, y, hu, false));
  }
  }

  
void update() {
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    
    p.update();

    if (p.done()) {
      particles.remove(i);
    }
  }
}
  
 void show() {
  for (Particle p : particles) {
    p.show();
  }
}
}
