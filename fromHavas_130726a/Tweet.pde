class Tweet {

  float x = 0;
  float y = 0;
  int opacity = 180;
  int k = 0;
  String username = "hi";
  String ImgUrl = null;
  PImage Img;

  // for arc
  Location havasLocation = new Location(40.722912, -74.007606);
  ArcLine myArc;

  boolean isClicked = false;
  int temp_i = 0;
  float opacity_2 = 20;
  Location myLocation;

  Tweet(Location myLocation_, String username_, String ImgUrl_) {
    myLocation = myLocation_;
    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;
    
    ImgUrl = ImgUrl_;
    if(ImgUrl != null) {
      Img = loadImage(ImgUrl);
    }
    username = username_;
    k = 0;
    myArc = new ArcLine();
  }

  void display() {
    havasMarker = new SimplePointMarker(havasLocation);
    ScreenPosition havasPos = havasMarker.getScreenPosition(map);
    float havasX = havasPos.x;
    float havasY = havasPos.y;
    
    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;
    
    String st = "("+x +", "+y+")";
    fill(235);
    textSize(20);
    textAlign(CENTER);

    if(dist(x,y,havasX,havasY)>width) {
      x = x/width;
      y = y/width;
    }
    myArc.display(havasX, havasY, x, y);

    if (myArc.cnt > myArc.num-1) {
      fill(0, 255, 255, 80);
      pushMatrix();
      strokeWeight(20);
      translate(x, y);
      drawSpread();
      popMatrix();
      noStroke();
    }
    
//    println(ImgUrl);
    if(ImgUrl != null) {
//      drawImg(); 
    }
  }
  
  void drawImg() {
    imageMode(CENTER);
    image(Img, x, y, 50, 50);
  }

  void drawSpread() {   
   // fill(255, 255 + opacity_2);
//    textFont(font, 25);
//    textSize(25);
//    textAlign(CENTER);
//    text("LOVE", 0,0);

    strokeWeight(2);
    int num = 14;
    int D = 30;

    float o = 255/num;
    float d = D/num;
    smooth();

    for (int i = 0; i < num; i++) {
      stroke(255, 255- i*o + opacity_2/2);
      //      stroke(0, 255, 255, 255- i*o + opacity_2);
      noFill();

      if (i == temp_i) {
        strokeWeight(4);
      } 
      else {
        strokeWeight(1);
      }

      pushMatrix();
      translate(0, 0, 0);//2*i);
      ellipse(0, 0, d*i, d*i);
      popMatrix();
    }

    temp_i++;

    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4;
  }

  void drawRadio() {

    strokeWeight(2);
    int num = 14;
    int D = 70;

    float o = 255/num;
    float d = D/num;
    smooth();

    for (int i = 0; i < num; i++) {
      stroke(0);
      noFill();

      pushMatrix();
      translate(0, 0, 0);//2*i);
      ellipse(0, 0, d*i, d*i);
      popMatrix();
    }

    stroke(0);// opacity_2*10);
    pushMatrix();
    translate(0, 0, 0);//2*temp_i);
    ellipse(0, 0, d*temp_i, d*temp_i);
    popMatrix();

    temp_i++;

    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4;
  }

  void drawRadio_2() {

    strokeWeight(1);
    int num = 10;
    int D = 50;

    float o = 255/num;
    float d = D/num;
    smooth();

    for (int i = 0; i < num; i++) {

      stroke(0, 255, 255, i*o + opacity);// + opacity_2);
      noFill();

      pushMatrix();
      translate(0, 0, 0);//2*i);
      ellipse(0, 0, d*i, d*i);
      popMatrix();
    }

    stroke(0);
    pushMatrix();
    translate(0, 0, 0);//2*temp_i);
    ellipse(0, 0, d*temp_i, d*temp_i);
    popMatrix();

    temp_i++;

    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4;
  }

  void drawTruncatedCone(float r1, float r2, float d1, float d2) {

    float ang = 0;
    int pts = 120;
    beginShape(TRIANGLES); //QUAD_STRIP // TRIANGLES
    for (int i=0; i<=pts; i++) { 

      float  px = cos(radians(ang))*r1;
      float  py = sin(radians(ang))*r1;
      vertex(px, py, d1);

      float  px2 = cos(radians(ang))*r2;
      float  py2 = sin(radians(ang))*r2;
      vertex(px2, py2, d2);
      ang+=360/pts;
    }
    endShape();
  }
}

