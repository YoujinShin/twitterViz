class Cvs {
  
  float lat = 0;
  float lon = 0;
  
  PVector pos = new PVector();
  PVector tpos = new PVector();
  
  PVector rot = new PVector();
  PVector trot = new PVector();
  
  Location tloc = new Location(40.7372, -73.9893);
  SimplePointMarker myMarker;
  
  Cvs() {
  }
  
  void update() {
    getPos();
    pos.x = lerp(pos.x, tpos.x, 0.5);
    pos.y = lerp(pos.y, tpos.y, 0.5);
  }
  
  void render() {
    pushMatrix();
      translate(pos.x, pos.y, 10);
      
      fill(255, 255, 255);
      stroke(255);
      ellipse(0, 0, 6, 6);
    popMatrix();
  }
  
  void getPos() {
    myMarker = new SimplePointMarker(tloc);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    tpos.x = myPos.x;
    tpos.y = myPos.y;
  }
}
