class Time {
  int s = 0;
  int m = 0;
  int h = 0;
  int d = 0;
  int mon = 0;
  int y = 0;
  String months;
  String sh, sm, ss;

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
    checkNum();
    String st = sh + " : " + sm + " : " + ss;  
    pushMatrix();
      translate(width*0.73,height*0.87,10);
      fill(0, 180);
      textSize(48);
      textAlign(CORNER);
      text(st, 0, 0); 
    popMatrix();
  }

  void cal_month() {
    if (mon == 1)  months ="January";
    if (mon == 2)  months ="February";
    if (mon == 3)  months ="March";
    if (mon == 4)  months ="April";
    if (mon == 5)  months ="May";
    if (mon == 6)  months ="June";
    if (mon == 7)  months ="July";
    if (mon == 8)  months ="August";
    if (mon == 9)  months ="September";
    if (mon == 10)  months ="October";
    if (mon == 11)  months ="November";
    if (mon == 12)  months ="December";
  }
  
  void checkNum() {
    if(h < 10)  sh = "0"+ h;
    else  sh = str(h);
    
    if(m < 10)  sm = "0"+ m;
    else  sm = str(m);
    
    if(s < 10)  ss = "0"+ s;
    else  ss = str(s);
  }
}

