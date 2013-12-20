class Fireworks {
  
  ArrayList<Particle> myParticle= new ArrayList();
  float x = 0;
  float y = 0;
  
  Fireworks() {
    for(int i = 0; i < 300; i ++) {
       Particle p = new Particle();
       myParticle.add(p);
    }
  }
  
  void display() {
    pushMatrix();
      //translate(x, y);
      for(int i = 0; i< 300; i++) {
         Particle p = myParticle.get(i);
         p.update();
         p.render(); 
      }
    popMatrix();
  }
}
