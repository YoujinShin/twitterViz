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
    String st = months +" " + d +", "+y+" at " + h + " : " + m + " : " + s + " EDT";
    fill(255);
//    textFont(font, 33);
    textSize(23);
    textAlign(CORNER);

    pushMatrix();
    translate(width*0.6,height*0.87,10);
//    translate(width*0.72,height*0.12,10);
    text(st, 0, 0); 
    popMatrix();
    
    
    // TITLE
    pushMatrix();
    textSize(25);
    translate(width*0.6,height*0.8,10);
    text("Real time twitter data visualization by Youjin", 0, 0); 
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

