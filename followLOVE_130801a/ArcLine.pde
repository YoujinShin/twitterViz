class ArcLine {

  int num = 80;
  int cnt = 0;
  int cntB = 0;
  float increment = PI/num;
  float strokeWidth = 0;

  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = 0;

  ArcLine() {
  }

  void display(float x1_, float y1_, float x2_, float y2_, int strokeWidth_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    strokeWidth = strokeWidth_/2.8;
    displayArc3D();
  }

  void displayArc3D() {
  
    float d1 = dist(x1, y1, 0, 0);
    float d2 = dist(x2, y2, 0, 0);
    float dia = dist(x1, y1, x2, y2);
    
    noFill();
    strokeWeight(strokeWidth);
    stroke(190,60,100); // 57
    
    pushMatrix();
    translate(x1, y1);

    pushMatrix();
    float theta = atan2(y2-y1, x2-x1);
    rotateZ(theta);

    pushMatrix();
    rotateX(-PI/2);
    //arc(dia/2, 0, dia, dia, PI+increment*cntB, PI+increment*cnt); // disappear
    arc(dia/2, 0, dia, dia, PI, PI+increment*cnt); // reamain

    popMatrix();
    popMatrix();
    popMatrix();

    cnt++;
    if (cnt > num) {
      cnt = num; 
      cntB++;
      if (cntB > num) {
        cntB = num;
      }
    }
  }
}

