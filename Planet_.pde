class Planet {
  PVector pos; //position
  float radius;
  float mass;
  
  Planet(float x, float y, float r) {
    pos = new PVector(x,y);
    radius = r;
    mass = radius * radius * 0.5; //mass depends on size 
  }
  
  void update() {
    mass = radius * radius * 0.5; //updates mass every frame 
  }
  
  void show() {
    fill(80,120,255);
    noStroke();
    circle(pos.x, pos.y, radius*2);
    
    fill(255);
    textSize(18);
    text("Radius:" + radius,20,30);
    text("Mass:" + mass, 20,55);
  }
  
  void handleKey(char k) {
    if (k=='+') {
      radius+=10;
    }
    if (k== '-') {
      radius -=10;
    }
    radius = constrain(radius,70,130); // max an minimum for radius 
  }
}
