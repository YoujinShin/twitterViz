
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

// twitter image
String myUrl = null;
String imageService[][] = { 
  { "http://yfrog.com",    "<meta property=\"og:image\" content=\""}, 
  {"http://twitpic.com",   "<img class=\"photo\" id=\"photo-display\" src=\""}, 
  {"http://img.ly",        "<img alt=\"\" id=\"the-image\" src=\"" }, 
  { "http://lockerz.com/", "<img id=\"photo\" src=\""}, 
  {"http://instagr.am/",   "<meta property=\"og:image\" content=\""}
};

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
PImage img;
PImage imgGet;

ArrayList urls;
ArrayList myTweets;
Time myTime;

Location temp_location;
Location centerLocation = new Location(33.305168, 2.650757); // lat long
Location havasLocation = new Location(40.722912, -74.007606);
Location firstLocation = new Location(40.732586, -74.007606);
Location secondLocation = new Location(37.319828, -26.880493);
EarthquakeMarker earthquakeMarker;

static public void main(String args[]) {
  Frame frame = new Frame("testing");
  frame.setUndecorated(true);
  // The name "sketch_name" must match the name of your program
  PApplet applet = new fromHavas_130717a();
  frame.add(applet);
  applet.init();
  frame.setBounds(0, 0, 1920*2, 1080); 
  frame.setVisible(true);
}

void setup() {
  size(1920*2, 1080, GLConstants.GLGRAPHICS); // 800, 600 // 1920, 1080
  smooth();
  frameRate(30);
  img = loadImage("havasMark2.gif");
//  font = loadFont("HelveticaNeue-CondensedBold-48.vlw");

  // unfolding map
  // String connStr = "jdbc:sqlite:" + ("/Users/youjin shin/Documents/Processing/control-room_c374b1.mbtiles");
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new MBTilesMapProvider(connStr));
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new MapBox.ControlRoomProvider());
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new Microsoft.RoadProvider());
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new Microsoft.AerialProvider());
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new OpenStreetMap.OpenStreetMapProvider());
  //  map = new UnfoldingMap(this, -700, -400, 1400, 800, new StamenMapProvider.TonerBackground());
  //  map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  //  map = new UnfoldingMap(this, new Microsoft.AerialProvider());
  map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
//  map.zoomAndPanTo(centerLocation, 2);
//  map.zoomAndPanTo(secondLocation, 3);
  map.zoomAndPanTo(firstLocation, 8);
//  map.zoomAndPanTo(firstLocation, 13);
  zoomLevel = 13;
  
  // twitter
  connectTwitter();
  twitter.addListener(listener);
  twitter.filter(new FilterQuery().track(keywords));

  myTweets = new ArrayList();
  myTime = new Time();
  earthquakeMarker = new EarthquakeMarker(havasLocation, img);
  
  // twitter images
  urls = new ArrayList();
}

void draw() {
  imageMode(CORNER);
  directionalLight(166, 166, 196, -60, -60, -60);
  background(0);
  map.draw();

  noStroke();
  fill(0, 170);
  rect(0, 0, width, height);

  if (TwitterOn) {
    myTweets.add(new Tweet(temp_location, username, myUrl));
    myUrl = null;
    StartOn = true;
  }
//  println(ImgUrl);

//  println("current url: " + myUrl);
  if (StartOn) {
    for (int i = 0; i < myTweets.size(); i++) {
      Tweet t = (Tweet) myTweets.get(i); 
      t.display();
    }
  }
  
  if (myTweets.size() > 10) {
    myTweets.remove(0);
  }
  
  TwitterOn = false;
  
  myTime.display();
  earthquakeMarker.display();

  
//  CNT = 1;
  if (frameCount % 600 == 0) {
    if (CNT == 1) {
      map.zoomAndPanTo(secondLocation, 3);
    }
    if (CNT == 2) {
//      map.zoomAndPanTo(centerLocation, 2);
      map.zoomAndPanTo(secondLocation, 3);
    }
    if (CNT == 3) {
      CNT = 0;
//      map.zoomAndPanTo(firstLocation, 13);
      map.zoomAndPanTo(firstLocation, 8);
    }
    CNT++;
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    
    /////////////////////////////////////////////////////////////////////
    String imgUrl = null;
    String imgPage = null;

    // Checks for images posted using twitter API

    if (status.getMediaEntities() != null) {
      imgUrl= status.getMediaEntities()[0].getMediaURL().toString();
    } else {
    // Checks for images posted using other APIs   
      if (status.getURLEntities().length > 0) {
        if (status.getURLEntities()[0].getExpandedURL() != null) {
          imgPage = status.getURLEntities()[0].getExpandedURL().toString();
        }
        else {
          if (status.getURLEntities()[0].getDisplayURL() != null) {
            imgPage = status.getURLEntities()[0].getDisplayURL().toString();
          }
        }
      }

      if (imgPage != null) imgUrl  = parseTwitterImg(imgPage);
    }

    if (imgUrl != null) {
      println("found image: " + imgUrl);

      // hacks to make image load correctly
      if (imgUrl.startsWith("//")){
        println("s3 weirdness");
        imgUrl = "http:" + imgUrl;
      }
      if (!imgUrl.endsWith(".jpg")) {
        byte[] imgBytes = loadBytes(imgUrl);
        saveBytes("tempImage.jpg", imgBytes);
        imgUrl = "tempImage.jpg";
      }      
//      if (!urls.contains(imgUrl)){ 
//        println("loading " + imgUrl);
//        img = loadImage(imgUrl);
//        urls.add(imgUrl);
//        imageLoaded = true;
//      }
      myUrl = imgUrl;
    } else {
      myUrl = null;
    }
//   println(imgUrl);
//   myUrl = imgUrl;
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

String parseTwitterImg(String pageUrl) {

  for (int i=0; i<imageService.length; i++) {
    if (pageUrl.startsWith(imageService[i][0])) {

      String fullPage = "";  // container for html
      String lines[] = loadStrings(pageUrl); // load html into an array, then move to container
      for (int j=0; j < lines.length; j++) { 
        fullPage += lines[j] + "\n";
      }

      String[] pieces = split(fullPage, imageService[i][1]);
      pieces = split(pieces[1], "\""); 

      return(pieces[0]);
    }
  }
  return(null);
}
