/*
 CVS Pharmacy Location JSON 
*/

String endPoint = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.7265734,-73.9939546&radius=5000&name=cvs+pharmacy&sensor=true&key=AIzaSyBstfudpeb40iOdjaD9SCTpiw7SOJBh0fU";
//String endPoint = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=40.7265734,-73.9939546&radius=10000&name=cvs&hasNextPage=true&nextPage()=true&sensor=true&key=AIzaSyBstfudpeb40iOdjaD9SCTpiw7SOJBh0fU";
String endPoint2;
String endPoint3;
String nextToken; // in order to get more than 20 results (maximum 60 re

float left_lon = -74.1900;
float right_lon = -73.7286;
float up_lat = 40.8590;
float down_lat = 40.6447;

PImage map_ny;

void setup() {
  size(510, 312);
  background(255);
  
  map_ny = loadImage("map_ny.png");
  image(map_ny, 0, 0);
  
  // LOAD FIRST END POINT
  JSONObject myJSON = loadJSONObject(endPoint); 
  JSONArray results = myJSON.getJSONArray("results");
  nextToken = myJSON.getString("next_page_token");
  println(results.size());
  println(nextToken);

  for(int i = 0; i < results.size(); i++) {
    JSONObject singleResult = results.getJSONObject(i);
    JSONObject geometry = singleResult.getJSONObject("geometry");
    JSONObject location = geometry.getJSONObject("location");
    
    float lng = location.getFloat("lng");
    float lat = location.getFloat("lat");
    
    if(lng > left_lon && lng < right_lon) {
      if(lat > down_lat && lat < up_lat) {
    
        float x = map(lng, left_lon, right_lon, 0, width);
        float y = map(lat, down_lat, up_lat, height, 0);
        println(lng + " " + lat);
        
        fill(255,0,0);
        stroke(255);
        ellipse(x, y, 5, 5);
      }
    }
  }
  
  // LOAD SECOND END POINT
  endPoint2 = endPoint + "&pagetoken=" + nextToken;
  println(endPoint);
  println(endPoint2);
}

