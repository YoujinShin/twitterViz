class ArcLine {
  int num = 60;
  int cnt = 0;
  int cntB = 0;
  float increment = PI/num;
  float strokeWidth = 0;
  float d = 0;

  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = 0;
  color color_set[] = new color[11];
  
  float tempX = 0;
  float tempY = 0;
  int temp_i = 0;
  Location tempPanLocation = new Location(0, 0);
  
  ArcLine() {
    getColor();
  }

  void display(float x1_, float y1_, float x2_, float y2_, int strokeWidth_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    strokeWidth = strokeWidth_*0.5;
    displayArc3D();
    temp_i = strokeWidth_;
  }

  void displayArc3D() {
    float d1 = dist(x1, y1, 0, 0);
    float d2 = dist(x2, y2, 0, 0);
    float dia = dist(x1, y1, x2, y2);
    noFill();
    strokeWeight(2);
    stroke(color_set[temp_i]);

    pushMatrix();
      translate(x1, y1);
    pushMatrix();
      float theta = atan2(y2-y1, x2-x1);
      rotateZ(theta);
    pushMatrix();
      rotateX(-PI/2);
      arc(dia/2, 0, dia, dia, PI, PI+increment*cnt);    
      // for panning
      float r = dia/2;
      d = r + r * cos(PI+increment*cnt);
      tempY = y1 + d*sin(theta); // lat
      tempX = x1 + d*cos(theta); // lon  
    popMatrix();  
    popMatrix();
    popMatrix();
    cnt++;
    if (cnt > num)  cnt = num;
  }
  
  void getColor() {
    color_set[0] = color(48, 77, 100);
    color_set[1] = color(198, 66, 65);
    color_set[2] = color(91, 70, 76);
    color_set[3] = color(323, 51, 64);
    color_set[4] = color(18, 84, 98);
    color_set[5] = color(7, 78, 88);
    color_set[6] = color(40, 91, 100);
    color_set[7] = color(192, 82, 84);
    color_set[8] = color(124, 57, 56);
    color_set[9] = color(295, 65, 61);
    color_set[10] = color(32, 80, 99);
  }
}
