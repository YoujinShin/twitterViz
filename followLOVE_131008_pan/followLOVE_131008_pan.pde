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

TwitterStream twitter = new TwitterStreamFactory().getInstance();
UnfoldingMap map;
SimplePointMarker myMarker;
SimplePointMarker havasMarker;

float lat = 0;
float lon = 0;
PFont font;

// panning
boolean TwitterOn = false;
boolean StartOn = false;
String username;
String keywords[] = {"love"};

ArrayList myFire = new ArrayList();
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
//  PApplet applet = new followLOVE_131008_pan();
//  frame.add(applet);
//  applet.init();
//  frame.setBounds(0, 0, 1920*2, 1080); 
//  frame.setVisible(true);
//}

void setup() {
  /* PROJECTION */
//  size(1920*2, 1080, GLConstants.GLGRAPHICS); // 800, 600 // 1920, 1080
//  font = createFont("/Users/madscience/Desktop/DROP/DS-DIGIB.TTF", 32); 
//  String connStr = "jdbc:sqlite:" + ("/Users/madscience/Desktop/DROP/basicMap.mbtiles");
  
  /* MONITOR */
  size(1400, 700, GLConstants.GLGRAPHICS);
  font = createFont("/Users/youjinshin/Documents/TwitterViz/followLove_131008_pan/data/DS-DIGIB.TTF", 32);
  String connStr = "jdbc:sqlite:" + ("/Users/youjinshin/Documents/Map/basicMap.mbtiles");

  // unfolding map
  map = new UnfoldingMap(this, new MBTilesMapProvider(connStr));
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
  map.zoomAndPanTo(centerLocation, 3);

  // twitter
  connectTwitter();
  twitter.addListener(listener);
  twitter.filter(new FilterQuery().track(keywords));
  myTweets = new ArrayList();
  myTime = new Time();
  pLocation = havasLocation;
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  imageMode(CORNER);
  directionalLight(166, 166, 196, -60, -60, -60);
  background(0);
  map.draw();

  if (TwitterOn) { // when new twitter comes
    Fireworks f = new Fireworks();
    myFire.add(f);
    
    Tweet t = new Tweet();
    t.myLocation = temp_location;
    t.pLocation = pLocation;
    t.username = username;
    myTweets.add(t);
    
    StartOn = true;
  }
  if (StartOn) {
    for (int i = 0; i < myTweets.size(); i++) {
      Tweet t = (Tweet) myTweets.get(i); 
      Fireworks f = (Fireworks) myFire.get(i);
      if (i > 1) {     
        Tweet tp = (Tweet) myTweets.get(i-1);
        if (tp.isDraw == true) t.display(i, f);
        if (t.isDraw == false) {
          Location panLocation = map.getLocation(t.panX, t.panY);
          if (abs(t.panX) > 0) map.panTo(panLocation);
        }
      } else {
        t.display(i, f);
      }
      pLocation = t.myLocation;
    }
  }  
  if (myTweets.size() > 10) {
    myTweets.remove(0);
    myFire.remove(0);
  }
  TwitterOn = false;
  myTime.display();
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

