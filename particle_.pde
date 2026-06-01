// Space animation end assignment Jasmin and Ha eun 
// class particle 
//used for the explosion sparks 

class Particle {
  PVector pos, vel, acc;
  float lifespan = 255; // controls fade out
  float hu;
  
  Particle( float x, float y, float hu, boolean explosion){
    pos = new PVector(x,y); //starting location of particle
    acc = new PVector(0,0);// starts with no accelaration
    this.hu = hu;
    
    if (!explosion) {
      vel = PVector.random2D(); // random direction in 2D
      vel.mult(random(2,10)); // random speed
    }
  } 
  
  void update() {
    
      vel.mult(0.9); // air resistance(slow down over time
      lifespan -=3;  // fade out 
    
    vel.add(acc);   // apply accelaration to velocity 
    pos.add(vel);  // apply velocity to position 
    acc.mult(0);   // reset acceleration 
  }
    boolean done() {// check ik particle is invisible 
    return (lifespan <0);
    }
    
   void show() {
  pushStyle();
  colorMode(HSB);

  strokeWeight(6);
  stroke(hu, 255, 255, lifespan);

  point(pos.x, pos.y);

  popStyle();
}
  }
