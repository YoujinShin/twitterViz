class Tweet {
  
  String userName;
  String twitterText;
  float lat = 0;
  float lon = 0;

  Location tloc = new Location(40.7372, -73.9893);
  SimplePointMarker myMarker;
  PImage img;
  
  PVector pos = new PVector();
  PVector tpos = new PVector();
  
  PVector rot = new PVector();
  PVector trot = new PVector();
  
  float t = random(100);
  color c = color(random(100), random(100), random(100));
  float opac = 0;
  int num = 0; // for color, time
  
  Tweet() {
  }
  
  void update() {
    getPos();
    pos.x = lerp(pos.x, tpos.x, 0.5);
    pos.y = lerp(pos.y, tpos.y, 0.5); 
    //rot.x = -PI/2;
    rot.x = -PI/4.5;
  }
  
  void render() {
    pushMatrix();
      translate(pos.x, pos.y, 20);  
      rotateX(rot.x);
      noStroke();
      
      num++;
      if(num < 100) {
        stroke(255, 0, 0, 200);
        fill(180, 24, 51, 180);
      } else if(num >=100 && num< 300) {
        stroke(255, 200);
        fill(255, 150);
      } else {
        float tnum = 255 - (num - 300)/4 - 80;
        if(tnum < 40) tnum = 40;
        stroke(255, tnum+20);
        fill(255, tnum);
      }
      
      triangle(0, 0, -10, -50, 10, -50);
    popMatrix();
  }
  
  void renderText() {
    textAlign(LEFT);
    pushMatrix();
      translate(pos.x, pos.y, 20);  
      rotateX(rot.x);
      fill(0, 255, 255, 160);
      stroke(0, 255, 255, 200);
      triangle(0, 0, -10, -50, 10, -50);
    popMatrix();
    
    pushMatrix();
      translate(pos.x, pos.y, 50);  
      rotateX(rot.x);
      fill(0, 255,255, 255);
      textFont(myFont);
      textSize(32);
      text(twitterText, 16, 0);
    popMatrix();
  }
  
  void getPos() {
    myMarker = new SimplePointMarker(tloc);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    tpos.x = myPos.x;
    tpos.y = myPos.y;
  }
  
  void displayDiameter(float x, float y) {
    t = t + 0.06;
    float d = noise(t);
    float opacLim = 120;
    
    if(frameCount % 15 == 0) opac++;
    if(opac > opacLim) opac = opacLim;
    
    fill(255, opacLim - opac);
    d = map(d, 0, 1, 10, 20);
    ellipse(x, y, d, d);
  }
}
