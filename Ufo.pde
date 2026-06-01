
class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed

    Boid(float x, float y) {
    acceleration = new PVector(0, 0);


    // Leaving the code temporarily this way so that this example runs in JS
   velocity = PVector.random2D();

    position = new PVector(x, y);
    r = 4.0;
    maxspeed = 2;
    maxforce = 0.07;
  }

 void run(ArrayList<Boid> boids, Asteroid asteroid) {
  flock(boids, asteroid);

  PVector planet = new PVector(width/2, height/2);
  PVector avoidForce = avoidPlanet(planet, 120);
  applyForce(avoidForce);

  update();
  borders();
  render();
}

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids, Asteroid asteroid) {
    PVector sep = separate(boids, asteroid);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(2.0);  //sep.mult(2.0);
    ali.mult(1.4); // ali.mult(1.4);
    coh.mult(1.0);   //coh.mult(0.8);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }
  
  // avoid planet 
  PVector avoidPlanet(PVector planetPosition, float planetRadius) {
  float d = PVector.dist(position, planetPosition);

  if (d < planetRadius + 80) {
    PVector away = PVector.sub(position, planetPosition);
    away.normalize();
    away.mult(maxspeed);

    PVector steer = PVector.sub(away, velocity);
    steer.limit(maxforce * 4);
    return steer;
  }

  return new PVector(0, 0);
}

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up
    
    fill(180, 180,220,120);
    stroke(255);
    

  pushMatrix();
  translate(position.x, position.y);
  rotate(theta);

  stroke(255);
  strokeWeight(2);

  // UFO dome
  fill(180, 220, 255, 200);
  arc(0, -r, r*4, r*2.5, PI, TWO_PI);

  // Main UFO body
  fill(170, 170, 190);
  ellipse(0, 0, r*6, r*2.2);

  // Bottom shadow/ring
  fill(100, 100, 130, 180);
  ellipse(0, r*0.5, r*4.5, r*0.8);

  // Lights
  fill(255, 255, 120);
  ellipse(-r*2, r*0.2, r*0.6, r*0.6);
  ellipse(0, r*0.5, r*0.6, r*0.6);
  ellipse(r*2, r*0.2, r*0.6, r*0.6);

  popMatrix();
  }

  // Wraparound
  void borders() {
  if (position.x < r || position.x > width - r) {
    velocity.x *= -1;
  }

  if (position.y < r || position.y > height - r) {
    velocity.y *= -1;
  }

  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids, Asteroid asteroid) {
    float desiredseparation = 40.0f; //25 pixels 
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) { //check every other ufo
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    
    
    
      float dAsteroid = PVector.dist(position, asteroid.pos);

  if (dAsteroid < asteroid.radius + 100) {
    PVector diff = PVector.sub(position, asteroid.pos);
    diff.normalize();
    diff.div(dAsteroid);
    diff.mult(5); // asteroid avoidance is stronger
    steer.add(diff);
    count++;
  }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 80;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 80;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }
}
