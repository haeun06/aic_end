class Planet {
  PVector pos; // position
  float radius;
  float mass;
  float flagTime = 0; //
  
//mass spring damper system variables
  float angle = 0;         // displacement (x) -> rotational angle of the flagpole
  float velocity = 0;      // velocity (v) -> angular v of the rotation
  float force = 0;         // external force (F) -> peak physical impulse from mouse click
  
  float springConstant = 0.6; // stiffness(k) -> restore toruqe towards 0 degrees
  float damping = 0.1;        // resistance -> energy dissipation over time
  float massStemSegment = 1.0; // intertia -> rotational mass of the flag stick

  Planet(float x, float y, float r) {
    pos = new PVector(x,y);
    radius = r;
    mass = radius * radius * 0.5; // mass depends on size 
  }
  
  void update() {
    mass = radius * radius * 0.5; // updates mass every frame 
    

    // F_spring = springConstant * angle
    // F_damping = damping * velocity
    //acc = (force - springforce - dampingforce)  / mass
    float acceleration = (force - (springConstant * angle) - (damping * velocity)) / massStemSegment;
    
    velocity += acceleration; // integrate acc into v
    angle += velocity; // integrate v into angular displacement
    
    force *= 0.85; // quick physical decay of the mouse press impulse
  }
  
  void show() {
    fill(80,120,255);
    noStroke();
    circle(pos.x, pos.y, radius*2);
    
    drawFlag(); // calls the flag and physcal drawing method
    
    fill(255);
    noStroke();
    textSize(18);
    text("Radius:" + radius, 20, 30);
    text("Mass:" + mass, 20, 55);
  }
  
  void drawFlag() {
    pushMatrix();
    translate(pos.x, pos.y - radius); // move origni to plantet's top (rotational pivot point)
    
    rotate(angle); // apllies the msds calculated angle to pole and flag
    
    // flag size
    float flagpoleHeight = radius * 1.5;
    float flagWidth = radius * 1.6;
    float flagHeight = radius * 1.0;
    
    // stick's size
    stroke(200); 
    strokeWeight(max(4, radius * 0.06)); // also sways via rotate()
    line(0, 0, 0, -flagpoleHeight); // bit straught up from pivot point
    noStroke();
    
    //flag color
    color[] dutchColors = {
      color(174, 28, 40),   // red
      color(255, 255, 255), // white
      color(33, 70, 139)    // blue
    };
    
    float stripeHeight = flagHeight / 3.0; // allocate equal height for the three section (color)
    
    // loops through three color to redner the flag cloth
    for (int s = 0; s < 3; s++) {
      fill(dutchColors[s]);
      beginShape(QUAD_STRIP); // use QUAD function for efficient mesh strip rendering
      
      for (float xOffset = 0; xOffset <= flagWidth; xOffset += 4) {
        //generate smooth continuous wave using perlin noise
        float noiseVal = noise(xOffset * 0.05, flagTime);
        float wave = map(noiseVal, 0, 1, -flagHeight * 0.1, flagHeight * 0.1) * (xOffset / flagWidth); 
        // multipes by (xoffset / flagwidth) so that cloth is anchored at x=0 and flutters at the top
        
        //calculate y vertices offset by the perlin noise wave variable
        float yTop = -flagpoleHeight + (s * stripeHeight) + wave;
        float yBottom = -flagpoleHeight + ((s + 1) * stripeHeight) + wave;
        
        vertex(xOffset, yTop); // top vertex point
        vertex(xOffset, yBottom); // bottom vertex point
      }
      endShape(); // completes current stripe color row
    }
    popMatrix(); // restores original position
  }
  
  // compute flag bounding box boundaries to detect mouse lick collision
  void checkFlagClick(float mx, float my) {

    float flagTopY = pos.y - radius - radius * 1.5;
    float flagBottomY = pos.y - radius;
    float flagLeftX = pos.x - 20; // extra left margin to easily cpature click
    float flagRightX = pos.x + radius * 1.6;
    
    if (mx >= flagLeftX && mx <= flagRightX && my >= flagTopY && my <= flagBottomY) { 
      // injects force into msds if mouse clic within the space
      force = 0.25; // trigger the physucs swing action
    }
  }
  
  void handleKey(char k) {
    if (k=='+') {
      radius+=10;
    }
    if (k== '-') {
      radius -=10;
    }
    radius = constrain(radius,70,130); 
  }
}
