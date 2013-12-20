import processing.core.*; 
import processing.xml.*; 

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
import de.fhpotsdam.unfolding.providers.MBTilesMapProvider; 
import de.fhpotsdam.unfolding.providers.Microsoft; 
import de.fhpotsdam.unfolding.providers.OpenStreetMap; 
import de.fhpotsdam.unfolding.providers.StamenMapProvider; 

import twitter4j.examples.block.*; 
import twitter4j.examples.trends.*; 
import twitter4j.conf.*; 
import twitter4j.json.*; 
import twitter4j.internal.async.*; 
import twitter4j.internal.logging.*; 
import org.ibex.nestedvm.util.*; 
import twitter4j.api.*; 
import twitter4j.internal.json.*; 
import twitter4j.examples.friendsandfollowers.*; 
import twitter4j.*; 
import twitter4j.examples.directmessage.*; 
import twitter4j.media.*; 
import twitter4j.examples.list.*; 
import twitter4j.examples.stream.*; 
import twitter4j.examples.search.*; 
import twitter4j.examples.friendship.*; 
import twitter4j.examples.timeline.*; 
import twitter4j.util.*; 
import org.sqlite.*; 
import org.ibex.nestedvm.*; 
import twitter4j.examples.tweets.*; 
import twitter4j.examples.user.*; 
import twitter4j.examples.async.*; 
import twitter4j.examples.help.*; 
import twitter4j.examples.media.*; 
import twitter4j.auth.*; 
import twitter4j.internal.util.*; 
import twitter4j.examples.account.*; 
import twitter4j.examples.geo.*; 
import twitter4j.internal.http.*; 
import twitter4j.examples.suggestedusers.*; 
import twitter4j.examples.spamreporting.*; 
import twitter4j.examples.oauth.*; 
import twitter4j.examples.favorite.*; 
import twitter4j.examples.json.*; 
import twitter4j.management.*; 
import twitter4j.examples.savedsearches.*; 
import twitter4j.internal.org.json.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class followLOVE_130807a_rotate extends PApplet {


// unfolding maps












 // add .jar file




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
Location havasLocation = new Location(40.722912f, -74.007606f);
Location firstLocation = new Location(41.754586f, -82.127606f);
Location secondLocation = new Location(37.319828f, -26.880493f);

static public void main(String args[]) {
  Frame frame = new Frame("testing");
  frame.setUndecorated(true);
  // The name "sketch_name" must match the name of your program
  PApplet applet = new followLOVE_130807a_rotate();
  frame.add(applet);
  applet.init();
  frame.setBounds(0, 0, 1920*2, 1080); 
  frame.setVisible(true);
}

public void setup() {
  size(1920*2, 1080, GLConstants.GLGRAPHICS); // 800, 600 // 1920, 1080
//  size(1400, 700, GLConstants.GLGRAPHICS);
  smooth();
//  font = createFont("/Users/youjinshin/Documents/TwitterViz/fromHavas_130730a/data/DS-DIGIB.TTF", 32);
//  font = createFont("/Users/madscience/Desktop/DROP/DS-DIGIB.TTF", 32);

  // unfolding map
//  String connStr = "jdbc:sqlite:" + ("/Users/youjinshin/Documents/Map/basicMap.mbtiles");
//  String connStr = "jdbc:sqlite:" + ("/Users/madscience/Desktop/DROP/basicMap.mbtiles");
//  map = new UnfoldingMap(this, new MBTilesMapProvider(connStr));
    map = new UnfoldingMap(this, new MapBox.ControlRoomProvider());
  //  map = new UnfoldingMap(this, new Microsoft.RoadProvider());
//  map = new UnfoldingMap(this,  new Microsoft.AerialProvider());
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

public void draw() {
  //  noCursor();
  imageMode(CORNER);
  directionalLight(166, 166, 196, -60, -60, -60);
  background(0);
  map.draw();

  noStroke();
  fill(0, 100);
  rect(0, 0, width, height);

  if (TwitterOn) {
    myTweets.add(new Tweet(temp_location, pLocation, username));
    StartOn = true;
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

  TwitterOn = false;
  myTime.display();

  if (frameCount % 600 == 0) {
    if (CNT == 1) {
      map.zoomAndPanTo(centerLocation, 2);
    }
    if (CNT == 2) {
      currentLat = lat;
      currentLon = lon;
    }
    CNT++;
    
    currentLat = lat;
    currentLon = lon;
    
    if (CNT > 2) {
      CNT = 1;
    }
  }

  panLat = r * cos(theta) + currentLat;
  panLon = r * sin(theta) + currentLon;
  theta = theta + 0.008f;
  Location panLocation = new Location(panLat, panLon);

  if (theta > 2*PI) {
    theta = 0;
  }

  if (CNT == 2) {
    map.zoomAndPanTo(panLocation, 4);
  }
  if (CNT == 1) {
    map.zoomAndPanTo(centerLocation, 3);
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
public void connectTwitter() {
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

class ArcLine {

  int num = 24;
  int cnt = 0;
  int cntB = 0;
  float increment = PI/num;
  float strokeWidth = 0;
  float d = 0;

  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = 0;

  ArcLine() {
  }

  public void display(float x1_, float y1_, float x2_, float y2_, int strokeWidth_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
//    strokeWidth = map(strokeWidth_, 0, 15, 30, 255);
    strokeWidth = strokeWidth_*0.5f;
    displayArc3D();
  }

  public void displayArc3D() {
    float d1 = dist(x1, y1, 0, 0);
    float d2 = dist(x2, y2, 0, 0);
    float dia = dist(x1, y1, x2, y2);
    
    noFill();
    strokeWeight(strokeWidth);
    stroke(190,60,100);
//    stroke(190,60,100,strokeWidth); // 57
    
    pushMatrix();
    translate(x1, y1);

    pushMatrix();
    float theta = atan2(y2-y1, x2-x1);
    rotateZ(theta);

    pushMatrix();
    rotateX(-PI/2);
    arc(dia/2, 0, dia, dia, PI, PI+increment*cnt);
    
    float r = dia/2;
    d = r * increment*cnt;
    println(d);

    popMatrix();
    popMatrix();
    popMatrix();

    cnt++;
    if (cnt > num) {
      cnt = num; 
    }
  }
}

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

  public void display() {
    d = day();    // Values from 1 - 31
    mon = month();  // Values from 1 - 12
    y = year();
    s = second();
    m = minute();
    h = hour();
    
    cal_month();
    checkNum();
    String st = sh + " : " + sm + " : " + ss; 
//    String st = months +" " + d +", "+y+" at " + h + " : " + m + " : " + s + " EDT";
//    String st = h + " : " + m + " : " + s;
    fill(0,0,100);
//    textFont(font, 35);
    textSize(30);
    textAlign(CORNER);

    pushMatrix();
    translate(width*0.6f,height*0.87f,10);
    text(st, 0, 0); 
    popMatrix();
    
    
    // TITLE
    pushMatrix();
    textSize(25);
    translate(width*0.6f,height*0.8f,10);
//    text("Real time twitter data visualization by Youjin", 0, 0); 
    popMatrix();
  }

  public void cal_month() {

    if (mon == 1) {
      months ="January";
    }
    if (mon == 2) {
      months ="February";
    }
    if (mon == 3) {
      months ="March";
    }
    if (mon == 4) {
      months ="April";
    }
    if (mon == 5) {
      months ="May";
    }
    if (mon == 6) {
      months ="June";
    }
    if (mon == 7) {
      months ="July";
    }
    if (mon == 8) {
      months ="August";
    }
    if (mon == 9) {
      months ="September";
    }
    if (mon == 10) {
      months ="October";
    }
    if (mon == 11) {
      months ="November";
    }
    if (mon == 12) {
      months ="December";
    }
  }
  
  public void checkNum() {
    if(h < 10) {
      sh = "0"+ h;
    } else {
      sh = str(h);
    }
    
    if(m < 10) {
      sm = "0"+ m;
    } else {
      sm = str(m);
    }
    
    if(s < 10) {
      ss = "0"+ s;
    } else {
      ss = str(s);
    }
  }
}

class Tweet {

  float x = 0;
  float y = 0;
  int opacity = 180;
  int k = 0;
  String username = "hi";
  boolean isDraw = false;

  // for arc
  Location havasLocation = new Location(40.722912f, -74.007606f);
  ArcLine myArc;

  boolean isClicked = false;
  int temp_i = 0;
  int strokeWidth = 0;
  float opacity_2 = 20;
  Location myLocation;

  Tweet(Location myLocation_, String username_) {
    myLocation = myLocation_;
    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;

    username = username_;
    k = 0;
    myArc = new ArcLine();
  }

  Tweet(Location myLocation_, Location havasLocation_, String username_) {
    myLocation = myLocation_;
    havasLocation = havasLocation_;
    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;

    username = username_;
    k = 0;
    myArc = new ArcLine();
  }

  public void display(int strokeWidth_) {
    havasMarker = new SimplePointMarker(havasLocation);
    ScreenPosition havasPos = havasMarker.getScreenPosition(map);
    float havasX = havasPos.x;
    float havasY = havasPos.y;
    strokeWidth = strokeWidth_;

    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;

    String st = "("+x +", "+y+")";
    fill(235);
    textSize(20);
    textAlign(CENTER);

    if (dist(x, y, havasX, havasY) > width) {
      x = x/width;
      y = y/width;
    }
    myArc.display(havasX, havasY, x, y, strokeWidth_);

    if (myArc.cnt > myArc.num-1) {
      isDraw = true;
      fill(0, 255, 255, 80);
      pushMatrix();
      strokeWeight(20);
      translate(x, y);
      drawSpreadNew();
      popMatrix();
      noStroke();
    }
  }

  public void drawSpreadNew() { 
    int num = 20;
    float D = map(strokeWidth,0,10,10,24);

    float o = 255/num;
    float d = (D/num);
    smooth();
    float H = 0, S = 0, B = 0;
    
    noStroke();
    fill(57, 18,100,100); // 57
    ellipse(0, 0, 10,10);
    ellipse(0, 0, 6,6);

    for (int i = 0; i < num; i++) {

      noFill();
      H = 57;//57
      S = map(i, 0, num, 0, 60);
      B = map(i, 0, num, 100, 100);
      stroke(H, S, B);
      strokeWeight(1);

      if (i == temp_i) {
        strokeWeight(1.2f);
        stroke(H, S, B);
      } 
      else {
        strokeWeight(1);
        noStroke();
      }

      ellipse(0, 0, d*i, d*i);
    }

    temp_i++;
    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4f;
  }

  public void drawSpread() {   
    strokeWeight(2);
    int num = 14;
    int D = 30;

    float o = 255/num;
    float d = D/num;
    smooth();

    for (int i = 0; i < num; i++) {
      stroke(255, 255- i*o + opacity_2/2);
      //      stroke(0, 255, 255, 255- i*o + opacity_2);
      noFill();

      if (i == temp_i) {
        strokeWeight(4);
      } 
      else {
        strokeWeight(1);
      }

      pushMatrix();
      translate(0, 0, 0);//2*i);
      ellipse(0, 0, d*i, d*i);
      popMatrix();
    }
    temp_i++;
    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4f;
  }

  public void drawRadio() {
    strokeWeight(2);
    int num = 14;
    int D = 70;

    float o = 255/num;
    float d = D/num;
    smooth();

    for (int i = 0; i < num; i++) {
      stroke(0);
      noFill();

      pushMatrix();
      translate(0, 0, 0);//2*i);
      ellipse(0, 0, d*i, d*i);
      popMatrix();
    }

    stroke(0);// opacity_2*10);
    pushMatrix();
    translate(0, 0, 0);//2*temp_i);
    ellipse(0, 0, d*temp_i, d*temp_i);
    popMatrix();

    temp_i++;
    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4f;
  }

  public void drawRadio_2() {

    strokeWeight(1);
    int num = 10;
    int D = 50;

    float o = 255/num;
    float d = D/num;
    smooth();

    for (int i = 0; i < num; i++) {
      stroke(0, 255, 255, i*o + opacity);// + opacity_2);
      noFill();

      pushMatrix();
      translate(0, 0, 0);//2*i);
      ellipse(0, 0, d*i, d*i);
      popMatrix();
    }

    stroke(0);
    pushMatrix();
    translate(0, 0, 0);//2*temp_i);
    ellipse(0, 0, d*temp_i, d*temp_i);
    popMatrix();

    temp_i++;
    if (temp_i > num) {
      temp_i = 0;
    }
    opacity_2 = opacity_2 - 0.4f;
  }

  public void drawTruncatedCone(float r1, float r2, float d1, float d2) {
    float ang = 0;
    int pts = 120;
    beginShape(TRIANGLES); //QUAD_STRIP // TRIANGLES
    for (int i=0; i<=pts; i++) { 

      float  px = cos(radians(ang))*r1;
      float  py = sin(radians(ang))*r1;
      vertex(px, py, d1);

      float  px2 = cos(radians(ang))*r2;
      float  py2 = sin(radians(ang))*r2;
      vertex(px2, py2, d2);
      ang+=360/pts;
    }
    endShape();
  }
}

}
