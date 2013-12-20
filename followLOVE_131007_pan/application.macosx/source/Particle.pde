class Particle {
  
  // Fireworks class 
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  Particle() {
    position = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }

  void update() {
    acceleration = new PVector(random(-1, 1), random(-1, 1));    
    acceleration.normalize(); 
    acceleration.mult(1.5); // number changes -> speed of fireworks
    velocity.add(acceleration);
    position.add(velocity);
  }
  
  void render() {
    fill(random(255), random(255), random(255));
    noStroke();
    ellipse(position.x, position.y, 1, 1);
  }
}

