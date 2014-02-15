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

// LOAD CVS LOCATION DATA (.txt)
BufferedReader myReader;
String ln;
ArrayList<Cvs> cvsList = new ArrayList();

// INITIALIZE MAP
UnfoldingMap map;
SimplePointMarker marker;
Location centerLocation = new Location(40.7372, -73.9893);

int t_width = 1280;
int t_height = 720;

// INITIALIZE TWEET
static String OAuthConsumerKey = "GAj6GT5dphiIh6kPF9a3w";
static String OAuthConsumerSecret = "duegkcBsu8N1FGPXtm9meu8axv0f8POc3YrXRA64lUc";
static String AccessToken = "159058059-teniAbzG4nqvrxdKUy9Rk91TFffAFgE78b01ADiG";
static String AccessTokenSecret = "2nI3I2ZXxHif2bCEJOslmKbPNhad55TWm674IlsyCMQrW";

TwitterStream twitter = new TwitterStreamFactory().getInstance();
boolean twitterOn = false;
boolean startOn = false;
ArrayList<Tweet> twitterList = new ArrayList();

double[][]geoLoc = {{-74.0952, 40.6728}, {-73.8769, 40.7904}};

PFont myFont;
float mylat = 0;
float mylon = 0;
String userName;
String twitterText;
Location currentLocation;

float distance = 1000000;
int seli = 0;

void setup() {
  background(0);
  size(t_width, t_height, GLConstants.GLGRAPHICS);
  
  // SETUP FOR THE MAP
  //map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  map = new UnfoldingMap(this, -t_width/2, -t_height, t_width*2, t_height*3, new StamenMapProvider.TonerBackground());
  
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
  map.zoomAndPanTo(centerLocation, 12);
  
  // SETUP FILE
  myReader = createReader("cvsLocations.txt");    
  readLocation();
  
  // SETUP TWEET
  connectTwitter();
  twitter.addListener(listener);
  twitter.filter(new FilterQuery().locations(geoLoc));
  myFont = loadFont("Blanch-Caps-48.vlw");
}
 
void draw() {
  background(0);
  
  translate(width/2, height/2);
  rotateX(PI/4.5);
  translate(-width/2, -height/2);
  
  imageMode(CORNER);
  map.draw();
  
  noStroke();
  fill(0, 140);
  rect(-t_width/2, -t_height, t_width*2, t_height*3);
  
  // RENDERING CVS
  for(int i = 0; i < cvsList.size(); i++) {
    Cvs c = cvsList.get(i);
    c.update();
    c.render();
    //println(c.pos.y);
  }
  
  // ADD TWEET
  if(twitterOn) {
    Tweet t = new Tweet();
    t.lon = mylon;
    t.lat = mylat;
    t.tloc = currentLocation;
    t.userName = userName;
    t.twitterText = twitterText;
    t.getPos();
    twitterList.add(t);
  }
  
  // REMOVE TWEET & RENDER TWEET
  int removeNum = -1;
  if(startOn) {
    for(int i = 0; i < twitterList.size(); i++) {
      Tweet t = twitterList.get(i);
      t.update();
      t.render();
    }
  }
  twitterOn = false;
  //if(removeNum > 0) twitterList.remove(removeNum);
  if(twitterList.size() > 100) twitterList.remove(0);
  checkDist();
} 

void checkDist() {
  for(int i = 0; i < twitterList.size(); i++) {
    Tweet t = new Tweet();
    t = twitterList.get(i);
    
    PVector mousePos = new PVector();
    mousePos.x = mouseX;
    mousePos.y = mouseY;
    
    if(mousePos.dist(t.tpos) < distance) {
      distance = mousePos.dist(t.tpos);
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

void readLocation() {
  try {
    while( (ln = myReader.readLine ()) != null) {
       if (ln == null) {
          // Stop reading because of an error or file is empty
          noLoop();  
        } else {
          String[] pieces = split(ln, " ");
          float lon = float(pieces[0]);
          float lat  = float(pieces[1]);
          //println(lon+", "+lat);
          
          Location tLocation = new Location(lat, lon);
          
          Cvs c = new Cvs();
          c.lon = lon;
          c.lat = lat; 
          c.tloc = tLocation;
          c.getPos();
          cvsList.add(c);
        }
    }
  } catch (IOException e) {
    e.printStackTrace();
    ln = null;
  }
}

////////////////////////////////////////////
////////////////////////////////////////////
////////////////////////////////////////////
////////////////////////////////////////////
////////////////////////////////////////////
////////////////////////////////////////////


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
    mylon = (float) status.getGeoLocation().getLongitude();
    mylat = (float) status.getGeoLocation().getLatitude();
    
    Location tLocation = new Location(mylat, mylon);
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

//  if (name.equals("gyro_gamma") == true) {
//    if (value >= 0 && value <= 1023) gyro_gamma = value;
//  }
//  
//  if (name.equals("gyro_beta") == true) {
//    if (value >= 0 && value <= 1023) gyro_beta = value;
//  }
}

// Our app only responds to integers, so do nothing here
void onBooleanMessage( String name, boolean value ){
  println("got bool message "+name +" : "+ value);  
}

// Our app only responds to integers, so do nothing here
void onStringMessage( String name, String value ){
  println("got string message "+name +" : "+ value);  
}

