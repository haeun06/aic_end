// The Flock (a list of Boid objects)

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
