
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

float lon = 0;
float lat = 0;
int num = 0;

boolean TwitterOn = false;
boolean StartOn = false;
boolean imageLoaded = false;
String username;

ArrayList myTweets;
Time myTime;

Location temp_location;
Location pLocation;
Location centerLocation = new Location(30, 0); // lat long
Location havasLocation = new Location(40.722912, -74.007606);
Location firstLocation = new Location(41.754586, -82.127606);
Location secondLocation = new Location(37.319828, -26.880493);
Location panLocation = centerLocation;

static public void main(String args[]) {
  Frame frame = new Frame("testing");
  frame.setUndecorated(true);
  // The name "sketch_name" must match the name of your program
  PApplet applet = new addLOVE_130802a();
  frame.add(applet);
  applet.init();
  frame.setBounds(0, 0, 1920*2, 1080); 
  frame.setVisible(true);
}

void setup() {
  size(1920*2, 1080, GLConstants.GLGRAPHICS); // 800, 600 // 1920, 1080
//  size(1200, 700, GLConstants.GLGRAPHICS);
  smooth();
//  font = createFont("/Users/youjinshin/Documents/TwitterViz/fromHavas_130730a/data/DS-DIGIB.TTF", 32);
  font = createFont("/Users/madscience/Desktop/DROP/DS-DIGIB.TTF", 32);

  // unfolding map
//  String connStr = "jdbc:sqlite:" + ("/Users/youjinshin/Documents/Map/map1.mbtiles");
  String connStr = "jdbc:sqlite:" + ("/Users/madscience/Desktop/DROP/basicMap.mbtiles");
  map = new UnfoldingMap(this, new MBTilesMapProvider(connStr));
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new MapBox.ControlRoomProvider());
//  map = new UnfoldingMap(this, new Microsoft.RoadProvider());
 //map = new UnfoldingMap(this,  new Microsoft.AerialProvider());
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new OpenStreetMap.OpenStreetMapProvider());
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new StamenMapProvider.TonerBackground());
  //  map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  //  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
//  map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
  map.zoomAndPanTo(centerLocation, 3);
  zoomLevel = 13;
  
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
//  noCursor();
  imageMode(CORNER);
  directionalLight(166, 166, 196, -60, -60, -60);
  background(0);
  map.draw();

  noStroke();
  fill(0, 180);
  rect(0, 0, width, height);

  if (TwitterOn) {
    myTweets.add(new Tweet(temp_location, pLocation, username));
    StartOn = true;
  }

  if (StartOn) {
    for (int i = 0; i < myTweets.size(); i++) {
      Tweet t = (Tweet) myTweets.get(i); 
      
      if(i > 1) {
        
        Tweet tp = (Tweet) myTweets.get(i-1);
        if(tp.isDraw == true) {
          t.display(i);
        }
        
      } else {
        t.display(i);
      }
      pLocation = t.myLocation;
    }
  }  
//  if (myTweets.size() > 10) {
//    myTweets.remove(0);
//  }
  
  TwitterOn = false;
  myTime.display();
  
  CNT = 1;
  if (frameCount % 300 == 3) {
    if (CNT == 1) {
      map.zoomAndPanTo(centerLocation, 3);
      panLocation = centerLocation;
    }
    if (CNT == 2) {
      map.zoomAndPanTo(havasLocation, 3);
      
    }
    if (CNT == 3) {
      CNT = 0;
      map.zoomAndPanTo(havasLocation, 4);
    }
    CNT++;
    if(CNT > 3) {
      CNT = 1;
    }
  }
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
