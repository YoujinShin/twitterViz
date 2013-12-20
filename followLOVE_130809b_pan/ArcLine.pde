class ArcLine {

  float num = 0;
  float cnt = 0;
  float linearVelocity = 8;
  float angularVelocity = 0; // determined by linear Velocity & radius

  float strokeWidth = 0;
  float d = 0;

  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = 0;

  float tempX = 0;
  float tempY = 0;
  Location tempPanLocation = new Location(0, 0);

  ArcLine() {
  }

  void display(float x1_, float y1_, float x2_, float y2_, int strokeWidth_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    //    strokeWidth = map(strokeWidth_, 0, 15, 30, 255);

    strokeWidth = strokeWidth_*0.5;
    displayArc3D_constTime();
//    displayArc3D_constVelocity();
  }

  void displayArc3D_constTime() {

    float d1 = dist(x1, y1, 0, 0);
    float d2 = dist(x2, y2, 0, 0);
    float dia = dist(x1, y1, x2, y2);
    float r = dia/2;
    angularVelocity = PI/50;
    num = PI/angularVelocity;

    noFill();
    strokeWeight(2);
    stroke(190, 90, 100, 200);

    pushMatrix();
    translate(x1, y1);

    pushMatrix();
    float theta = atan2(y2-y1, x2-x1);
    rotateZ(theta);

    pushMatrix();
    rotateX(-PI/2);
    arc(dia/2, 0, dia, dia, PI, PI+angularVelocity*cnt);    

    // for panning
    d = r + r * cos(PI+angularVelocity*cnt);
    tempY = y1 + d*sin(theta); // lat
    tempX = x1 + d*cos(theta); // lon  

    popMatrix();
    popMatrix();
    popMatrix();

    cnt++;
    if (cnt > num) {
      cnt = num;
    }
  }

  void displayArc3D_constVelocity() {

    float d1 = dist(x1, y1, 0, 0);
    float d2 = dist(x2, y2, 0, 0);
    float dia = dist(x1, y1, x2, y2);
    float r = dia/2;
    angularVelocity = linearVelocity/r;
    num = PI/angularVelocity;

    noFill();
    //    strokeWeight(strokeWidth*0.8);
    strokeWeight(2);
    //    stroke(0,0,100,200);
    //    stroke(190, 50, 90); // 190, 60, 100
    stroke(190, 90, 100, 200);
    //    stroke(190,60,100,strokeWidth); // 57

    pushMatrix();
    translate(x1, y1);

    pushMatrix();
    float theta = atan2(y2-y1, x2-x1);
    rotateZ(theta);

    pushMatrix();
    rotateX(-PI/2);
    arc(dia/2, 0, dia, dia, PI, PI+angularVelocity*cnt);    

    // for panning
    d = r + r * cos(PI+angularVelocity*cnt);
    tempY = y1 + d*sin(theta); // lat
    tempX = x1 + d*cos(theta); // lon  

    popMatrix();
    popMatrix();
    popMatrix();

    cnt++;
    if (cnt > num) {
      cnt = num;
    }
  }
}

