//CreaTe Y1
//space animation end assignment for aic
//Jasmin Jansen(s3720527) and HaEun Kwack(s3594572)
// The Flock class that stores and manages the arraylist of UFOs

class Flock {
  ArrayList<Ufo> ufos; // An ArrayList for all the boids

  Flock() {
    ufos = new ArrayList<Ufo>(); // Initialize the ArrayList
  }

  void run() {
    for (Ufo u : ufos) {
      u.run(ufos, asteroid, planet);  // Passing the entire list of boids to each boid individually
    }
  }

  void addUfo(Ufo u) {
    ufos.add(u);
  }

}
