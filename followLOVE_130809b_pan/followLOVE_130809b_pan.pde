
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

// twitter (add .jar file): oauth info & access token info
static String OAuthConsumerKey = "VVIy5oJeMX2yFQCWEIOdZg";
static String OAuthConsumerSecret = "HSh2RyGtUfuNZdbJwTVJNsu7xPn4HBQUPqRQWfsA";
static String AccessToken = "159058059-NSkrkHQP8YT2E33vSvs3xucJEtLRa63u0CnLRELj";
static String AccessTokenSecret = "gV8k9tWSiqBqUavY5HwV7Gi0YnjbHZWUegifu6aXLo";

PFont font;
int zoomLevel = 1;
int CNT = 1;

String keywords[] = {
  "love"//"love" //love //@havasww
};

TwitterStream twitter = new TwitterStreamFactory().getInstance();
UnfoldingMap map;
SimplePointMarker myMarker;
SimplePointMarker havasMarker;

float lat = 0;
float lon = 0;
int num = 0;

// panning
float panLat = 0;
float panLon = 0;
float r = 12;
float theta = 0;
float currentLat = 0;
float currentLon = 0;

boolean TwitterOn = false;
boolean StartOn = false;
boolean imageLoaded = false;
String username;

ArrayList myTweets;
Time myTime;

Location temp_location;
Location pLocation;
Location centerLocation = new Location(30, 0); // lat ldong
Location havasLocation = new Location(40.722912, -74.007606);
Location firstLocation = new Location(41.754586, -82.127606);
Location secondLocation = new Location(37.319828, -26.880493);

//static public void main(String args[]) {
//  Frame frame = new Frame("testing");
//  frame.setUndecorated(true);
//  // The name "sketch_name" must match the name of your program
//  PApplet applet = new followLOVE_130809b_pan();
//  frame.add(applet);
//  applet.init();
//  frame.setBounds(0, 0, 1920*2, 1080); 
//  frame.setVisible(true);
//}

void setup() {
  // for projection
//  size(1920*2, 1080, GLConstants.GLGRAPHICS); // 800, 600 // 1920, 1080
//  font = createFont("/Users/madscience/Desktop/DROP/DS-DIGIB.TTF", 32);
//  String connStr = "jdbc:sqlite:" + ("/Users/madscience/Desktop/DROP/geographyClass.mbtiles"); 

  // for monitor
  size(1400, 700, GLConstants.GLGRAPHICS);
  font = createFont("/Users/youjinshin/Documents/TwitterViz/fromHavas_130730a/data/DS-DIGIB.TTF", 32);
  String connStr = "jdbc:sqlite:" + ("/Users/youjinshin/Documents/Map/geographyClass.mbtiles");
  
  // unfolding map
  map = new UnfoldingMap(this, new MBTilesMapProvider(connStr));
//  map = new UnfoldingMap(this, new MapBox.ControlRoomProvider());
//  map = new UnfoldingMap(this, new Microsoft.RoadProvider());
//  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
//  map = new UnfoldingMap(this, new OpenStreetMap.OpenStreetMapProvider());
//  map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
  map.setBackgroundColor(255); // int bgColor
  map.zoomAndPanTo(centerLocation, 3);
  zoomLevel = 13;
  
  smooth();
  colorMode(HSB, 360, 100, 100);

  // twitter
  connectTwitter();
  twitter.addListener(listener);
  twitter.filter(new FilterQuery().track(keywords));

  myTweets = new ArrayList();
  myTime = new Time();
  pLocation = havasLocation;
}

void draw() {
  //  noCursor();
  imageMode(CORNER);
  directionalLight(166, 166, 196, -60, -60, -60);
  background(190, 60, 100);
  noStroke();
  map.draw();

  if (TwitterOn) {
    myTweets.add(new Tweet(temp_location, pLocation, username));
    StartOn = true;
    pushMatrix();
    translate(width*0.84,height*0.86);
    drawLoveR(0.5);
    popMatrix();
  }

  if (StartOn) {
    for (int i = 0; i < myTweets.size(); i++) {
      Tweet t = (Tweet) myTweets.get(i); 
      //      t.display(i);
      if (i > 1) {     
        Tweet tp = (Tweet) myTweets.get(i-1);
        if (tp.isDraw == true) {
          t.display(i);
        }

        if (t.isDraw == false) {
          Location panLocation = map.getLocation(t.panX, t.panY);
          if (abs(t.panX) > 0) {
            map.panTo(panLocation);
          }
        }
      } 
      else {
        t.display(i);
      }
      pLocation = t.myLocation;
    }
  }  
  if (myTweets.size() > 10) {
    myTweets.remove(0);
  }

  noStroke();
  fill(0, 100);//, 100); //50, 13, 54
  rect(0, height*0.81, width, height*0.1);

  TwitterOn = false;
  myTime.display();
}

void drawLove(float a_) {
  float a = a_;
  pushMatrix();
  translate(-50*a, -50*a);

  beginShape();
  noStroke();
//  stroke(0, 0, 100);
//  strokeWeight(1);
//  fill(51, 15, 99, 170);
  noFill();
  vertex(50*a, 35*a);
  bezierVertex(90*a, 0, 90*a, 70*a, 50*a, 80*a);
  bezierVertex(10*a, 70*a, 10*a, 0, 50*a, 35*a);
  endShape();
  popMatrix();
}

void drawLoveR(float a_) {
  float a = a_;
  pushMatrix();
  translate(-50*a, -50*a);

  beginShape();
  noStroke();
//  stroke(0, 0, 100);
//  strokeWeight(1);
  fill(10, 90, 90);
  vertex(50*a, 35*a);
  bezierVertex(90*a, 0, 90*a, 70*a, 50*a, 80*a);
  bezierVertex(10*a, 70*a, 10*a, 0, 50*a, 35*a);
  endShape();
  popMatrix();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    //    println("@" + status.getUser().getScreenName() + " - " + status.getText() + " - " + status.getGeoLocation());
    lon = (float) status.getGeoLocation().getLongitude();
    lat = (float) status.getGeoLocation().getLatitude();

    Location myLocation = new Location(lat, lon);
    temp_location = myLocation;
    username = status.getUser().getScreenName();
    TwitterOn = true;
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

