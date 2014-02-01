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
      translate(width*0.98,-height*0.28,10);
      //translate(width*0.8,height*0.9,10);
      fill(0,100);
      noStroke();
      rotateX(-PI/4.5);
      rect(0-width*0.04,-height*0.042, width*0.22, height*0.058);
      
      translate(width*0.15,0);
      
      fill(255);     
      textAlign(RIGHT);
      textFont(myFont);
      textSize(int(height*0.05));
      text(st, 25, 0); 
      
      fill(180, 24, 51);
      text("talk in new york", -width*0.06,0);
      //text("FOLLOW", -width*0.15,0);
//      
//      fill(3, 55 ,100);
//      text("LOVE    ", -width*0.06, 0);
//      
//      fill(212, 22, 47,180);
//      text("|", -width*0.06, 0);
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

