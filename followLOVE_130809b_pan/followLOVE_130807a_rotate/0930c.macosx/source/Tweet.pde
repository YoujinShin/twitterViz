class Tweet {

  float x = 0;
  float y = 0;
  int opacity = 180;
  int k = 0;
  String username = "hi";
  boolean isDraw = false;

  // for arc
  Location havasLocation = new Location(40.722912, -74.007606);
  ArcLine myArc;

  boolean isClicked = false;
  int temp_i = 0;
  int strokeWidth = 0;
  float opacity_2 = 20;
  Location myLocation;

  Tweet(Location myLocation_, String username_) {
    myLocation = myLocation_;
    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;

    username = username_;
    k = 0;
    myArc = new ArcLine();
  }

  Tweet(Location myLocation_, Location havasLocation_, String username_) {
    myLocation = myLocation_;
    havasLocation = havasLocation_;
    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;

    username = username_;
    k = 0;
    myArc = new ArcLine();
  }

  void display(int strokeWidth_) {
    havasMarker = new SimplePointMarker(havasLocation);
    ScreenPosition havasPos = havasMarker.getScreenPosition(map);
    float havasX = havasPos.x;
    float havasY = havasPos.y;
    strokeWidth = strokeWidth_;

    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;

    String st = "("+x +", "+y+")";
    fill(235);
    textSize(20);
    textAlign(CENTER);

    if (dist(x, y, havasX, havasY) > width) {
      x = x/width;
      y = y/width;
    }
    myArc.display(havasX, havasY, x, y, strokeWidth_);

    if (myArc.cnt > myArc.num-1) {
      isDraw = true;
      fill(0, 255, 255, 80);
      pushMatrix();
      strokeWeight(20);
      translate(x, y);
      drawSpreadNew();
      popMatrix();
      noStroke();
    }
  }

  void drawSpreadNew() { 
    int num = 20;
    float D = map(strokeWidth,0,10,10,24);

    float o = 255/num;
    float d = (D/num);
    smooth();
    float H = 0, S = 0, B = 0;
    
    noStroke();
    fill(57, 18,100,100); // 57
    ellipse(0, 0, 10,10);
    ellipse(0, 0, 6,6);

    for (int i = 0; i < num; i++) {

      noFill();
      H = 57;//57
      S = map(i, 0, num, 0, 60);
      B = map(i, 0, num, 100, 100);
      stroke(H, S, B);
      strokeWeight(1);

      if (i == temp_i) {
        strokeWeight(1.2);
        stroke(H, S, B);
      } 
      else {
        strokeWeight(1);
        noStroke();
      }

      ellipse(0, 0, d*i, d*i);
    }

    temp_i++;
    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4;
  }

  void drawSpread() {   
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

