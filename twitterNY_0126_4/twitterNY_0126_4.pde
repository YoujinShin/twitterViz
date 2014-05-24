// unfolding maps
import processing.opengl.*;
import processing.core.PGraphics;
import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.geo.Location;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.marker.SimplePointMarker;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.utils.ScreenPosition;
import de.fhpotsdam.unfolding.providers.*;
import de.fhpotsdam.unfolding.providers.MapBox;
import de.fhpotsdam.unfolding.providers.MBTilesMapProvider; // add .jar file
import de.fhpotsdam.unfolding.providers.Microsoft;
import de.fhpotsdam.unfolding.providers.OpenStreetMap;
import de.fhpotsdam.unfolding.providers.StamenMapProvider;

// spacebrew
import spacebrew.*;
import processing.serial.*;
String server="sandbox.spacebrew.cc";
String name="yj";
String description ="The range of 0 to 1023";
Spacebrew c;

//int gyro_alpha = 0; // z axis rotation
int gyro_beta = 0; // up and down
int gyro_gamma = 0; // left and right

float pan_lon = -73.9893;
float pan_lat = 40.7372;

float pan_tlon = -73.9893;
float pan_tlat = 40.7372;

float cen_lon = -73.9893;
float cen_lat = 40.7372;

float distance = 1000000;
int seli = 0;
Time myTime;

// twitter (add .jar file): oauth info & access token info
static String OAuthConsumerKey = "GAj6GT5dphiIh6kPF9a3w";
static String OAuthConsumerSecret = "duegkcBsu8N1FGPXtm9meu8axv0f8POc3YrXRA64lUc";
static String AccessToken = "159058059-teniAbzG4nqvrxdKUy9Rk91TFffAFgE78b01ADiG";
static String AccessTokenSecret = "2nI3I2ZXxHif2bCEJOslmKbPNhad55TWm674IlsyCMQrW";

TwitterStream twitter = new TwitterStreamFactory().getInstance();
String keywords[] = {"I feel"};
String userName;
String twitterText;
float lat = 0;
float lon = 0;
boolean twitterOn = false;
boolean startOn = false;
ArrayList<Tweet> twitterList = new ArrayList();

// -74, 40, -73, 41  New York City
float minLon = -74;
float minLat = 40;
float maxLon = -73;
float maxLat = 41;
//double[][]geoLoc = {{-74, 40}, {-73, 41}}; // lon, lat
double[][]geoLoc = {{-74.0952, 40.6728}, {-73.8769, 40.7904}};
PImage img;
PFont myFont;
boolean tiltOn = false;

PVector pan_pos = new PVector();  // location info (x -> lon, y -> lat)
PVector pan_tpos = new PVector(); // location info (x -> lon, y -> lat)
PVector mpos = new PVector();

//int t_width = 1280;
//int t_height = 720;

int t_width = int(1280);
int t_height = int(720);

//int t_width = 1920;
//int t_height = 1080;

UnfoldingMap map;
SimplePointMarker marker;
Location centerLocation = new Location(40.7372, -73.9893); // lat, lon (y, x)
Location currentLocation;

void setup() {
  background(0);
  //size(1920, 1080, GLConstants.GLGRAPHICS);
  size(t_width, t_height, GLConstants.GLGRAPHICS);
  //size(displayWidth, t_height, GLConstants.GLGRAPHICS);

  
  //img = loadImage("texture.png");
  myFont = loadFont("Blanch-Caps-48.vlw");
  //myFont = loadFont("/Users/youjinshin/Desktop/Blanch-Caps-48.vlw");
  //myFont = createFont("/Users/youjinshin/Desktop/Blanch-Caps-48.vlw", 32); 
  
  pan_pos.x = -73.9893;
  pan_pos.y = 40.7372;
  pan_tpos.x = -73.9893;
  pan_tpos.y = 40.7372;
  
  //unfolding map
//  map = new UnfoldingMap(this,-t_width/2, -t_height, t_width*2, t_height*3, new MapBox.ControlRoomProvider());
//  map = new UnfoldingMap(this, -t_width/2, -t_height, t_width*2, t_height*3,new Microsoft.RoadProvider());
//  map = new UnfoldingMap(this, -t_width/2, -t_height, t_width*2, t_height*3,new Microsoft.AerialProvider());
  map = new UnfoldingMap(this, -t_width/2, -t_height, t_width*2, t_height*3, new StamenMapProvider.TonerBackground());

  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
  map.zoomAndPanTo(centerLocation, 14);
  
  // spacebrew
  c = new Spacebrew( this );
  c.addPublish( "gyro_gamma", gyro_gamma ); // add each thing you publish to
  c.addSubscribe( "gyro_gamma", "range" ); // add each thing you subscribe to
  
  c.addPublish( "gyro_beta", gyro_beta ); // add each thing you publish to
  c.addSubscribe( "gyro_beta", "range" ); // add each thing you subscribe to
  
  c.connect("ws://"+server+":9000", name, description );
  
  // twitter
  connectTwitter();
  twitter.addListener(listener);
  twitter.filter(new FilterQuery().locations(geoLoc));
  //twitter.filter(new FilterQuery().track(keywords));
  
  myTime = new Time();
}

void draw() {
  background(0);
  mpos.x = mouseX;
  mpos.y = mouseY;
  
  translate(width/2, height/2);
  rotateX(PI/4.5);
  translate(-width/2, -height/2);
  
  imageMode(CORNER);
  map.draw();
  fill(0, 160);
  rect(-t_width/2, -t_height, t_width*2, t_height*3);
  
  blendMode(ADD);
  if(twitterOn) {
    Tweet t = new Tweet();
    t.lon = lon;
    t.lat = lat;
    t.tloc = currentLocation;
    t.userName = userName;
    t.twitterText = twitterText;
    t.img = img;
    t.getPos();
    twitterList.add(t);
  }
  
  int removeNum = -1;
  if(startOn) {
    for(int i = 0; i < twitterList.size(); i++) {
      Tweet t = twitterList.get(i);
      t.update();
      t.render();
      //if(t.opac > 79) removeNum = i;
    }
  }
  twitterOn = false;
  //if(removeNum > 0) twitterList.remove(removeNum);
  if(twitterList.size() > 100) twitterList.remove(0);
  
  pan_tlon = map(gyro_gamma, 0, 1023, cen_lon-0.13, cen_lon+0.16); 
  pan_tlat = map(gyro_beta, 1023, 0, cen_lat-0.12, cen_lat+0.22);
  
  pan_lon = lerp(pan_lon, pan_tlon, 0.01);
  pan_lat = lerp(pan_lat, pan_tlat, 0.01);
  
  Location pan_tloc = new Location(pan_tlat, pan_tlon); // lat, lon
  marker = new SimplePointMarker(pan_tloc);
  ScreenPosition temp_pos = marker.getScreenPosition(map);
  pan_tpos.x = temp_pos.x;
  pan_tpos.y = temp_pos.y;
  
  textSize(50);
  fill(255, 0, 0, 180);

  noStroke();
  pushMatrix();
    translate(pan_tpos.x, pan_tpos.y, 10);
    //ellipse(0, 0, 30, 30);
  popMatrix();
  
  fill(0, 255, 255, 140);
  Location pan_loc = new Location(pan_lat, pan_lon); // lat, lon
  marker = new SimplePointMarker(pan_loc);
  temp_pos = marker.getScreenPosition(map);
  pan_pos.x = temp_pos.x;
  pan_pos.y = temp_pos.y;

  pushMatrix();
    translate(pan_pos.x, pan_pos.y, 10);
    ellipse(0, 0, 30, 30);
  popMatrix();

  map.panTo(pan_loc);
  checkDist();
  myTime.display();
}

void checkDist() {
  for(int i = 0; i < twitterList.size(); i++) {
    Tweet t = new Tweet();
    t = twitterList.get(i);
    
    if(pan_pos.dist(t.tpos) < distance) {
      distance = pan_pos.dist(t.tpos);
      seli = i;
    }
  }
  
  if(distance < 150) {
    Tweet t = new Tweet();
    t = twitterList.get(seli);
    t.renderText();
    
    distance = 1000000;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////

void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}
StatusListener listener = new StatusListener() {
  public void onStatus(Status status) {
    lon = (float) status.getGeoLocation().getLongitude();
    lat = (float) status.getGeoLocation().getLatitude();
    
    Location tLocation = new Location(lat, lon);
    currentLocation = tLocation;

    userName = status.getUser().getScreenName();
    twitterText = status.getText();
    twitterOn = true;
    startOn = true;
  }
  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
  public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }
  public void onException(Exception ex) {
    ex.printStackTrace();
  }
  public void onStallWarning(StallWarning warning) {
  }
};

void onRangeMessage( String name, int value ){
  //println("got int message " + name + " : " + value);

  if (name.equals("gyro_gamma") == true) {
    if (value >= 0 && value <= 1023) gyro_gamma = value;
  }
  
  if (name.equals("gyro_beta") == true) {
    if (value >= 0 && value <= 1023) gyro_beta = value;
  }
}

// Our app only responds to integers, so do nothing here
void onBooleanMessage( String name, boolean value ){
  println("got bool message "+name +" : "+ value);  
}

// Our app only responds to integers, so do nothing here
void onStringMessage( String name, String value ){
  println("got string message "+name +" : "+ value);  
}
