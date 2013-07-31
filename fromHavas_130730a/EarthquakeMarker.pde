class EarthquakeMarker extends SimplePointMarker {

  Location myLocation;
  PGraphics pg;
  PImage img;
  float x, y;

  int opacity = 180;
  int k = 0;
  float temp_i = 0;
  float opacity_2 = 20;

  EarthquakeMarker(Location myLocation_) {
    pg = createGraphics(100, 100, P3D);
    myLocation = myLocation_;
//    img = img_;
  }

  void display() {
    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;
    
    pushMatrix();
    translate(x, y,2);
    displaySpread();
    popMatrix();

    imageMode(CORNER);
    int w = 180;
    int h = 170;

//    pushMatrix();
//    translate(x-0.3*w, y-0.8*h,4);
//    fill(255, 0, 0);
//    image(img, 0,0, w, h);
//    popMatrix();
    
    pushMatrix();
    translate(x, y, 4);
    noStroke();
    fill(0, 255, 255, 180);
    ellipse(0,0,16, 16);
    popMatrix();
  }

  void displaySpread() {

    strokeWeight(2);
    int num = 22;
    int D = 50;

    float o = 255/num;
    float d = D/num;
    smooth();

    for (int i = 0; i < num; i++) {
      //      stroke(0, 255, 255, 255- i*o);
      //      stroke(255, 255- i*o);
      //      noFill();
      if (i == temp_i) {
        stroke(0, 255,255, 180);
        noFill();
        strokeWeight(0.5);
      } 
      else {
        stroke(0,255,255, 255- i*o*1.2);
        strokeWeight(0.5); 
        noFill();
      }

      pushMatrix();
      translate(0, 0, 0);//2*i);
      ellipse(0, 0, d*i, d*i);
      popMatrix();
    }

    temp_i = temp_i +1;

    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4;
  }
}

