class Time {

  int s = 0;
  int m = 0;
  int h = 0;
  int d = 0;
  int mon = 0;
  int y = 0;
  String months;

  Time() {
  }

  void display() {
    d = day();    // Values from 1 - 31
    mon = month();  // Values from 1 - 12
    y = year();
    s = second();
    m = minute();
    h = hour();
    
    cal_month();
//    String st = months +" " + d +", "+y+" at " + h + " : " + m + " : " + s + " EDT";
    String st = h + " : " + m + " : " + s;
//    fill(0,0,100);
    fill(51, 15, 99, 180);
    textFont(font, 35);
    textAlign(CORNER);

    pushMatrix();
    translate(width*0.7,height*0.87,10);
    text(st, 0, 0); 
    popMatrix();
    
    
    // TITLE
    pushMatrix();
    textSize(35);
    fill(51, 15, 99, 140);
    translate(width*0.02,height*0.8,10);
    text("following LOVE", 120, 40);//", 0, 0); 
    popMatrix();
  }

  void cal_month() {

    if (mon == 1) {
      months ="January";
    }
    if (mon == 2) {
      months ="February";
    }
    if (mon == 3) {
      months ="March";
    }
    if (mon == 4) {
      months ="April";
    }
    if (mon == 5) {
      months ="May";
    }
    if (mon == 6) {
      months ="June";
    }
    if (mon == 7) {
      months ="July";
    }
    if (mon == 8) {
      months ="August";
    }
    if (mon == 9) {
      months ="September";
    }
    if (mon == 10) {
      months ="October";
    }
    if (mon == 11) {
      months ="November";
    }
    if (mon == 12) {
      months ="December";
    }
  }
}

