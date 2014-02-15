/*
 CVS Pharmacy Location Text
*/

String[] lines;
float left_lon = -74.1900;
float right_lon = -73.7286;
float up_lat = 40.8590;
float down_lat = 40.6447;

PImage map_ny;

void setup() {
  size(510*2, 312*2);
  background(255);
  
  map_ny = loadImage("map_ny.png");
  image(map_ny, 0, 0, width, height);

  lines = loadStrings("cvsLocations.txt");
  println(lines.length);
  
  for(int i = 0; i < lines.length; i++) {
    String[] pieces = split(lines[i], " ");
    float lon = float(pieces[0]);
    float lat = float(pieces[1]);
    //println(lon +", "+lat);
    
    float x = map(lon, left_lon, right_lon, 0, width);
    float y = map(lat, down_lat, up_lat, height, 0);
    
    fill(255,0,0);
    stroke(255);
    ellipse(x, y, 9, 9);
  }
  //println(lines);
}

