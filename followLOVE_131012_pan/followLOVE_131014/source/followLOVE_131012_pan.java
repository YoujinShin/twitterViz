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

public class followLOVE_131012_pan extends PApplet {

// unfolding maps












 // add .jar file




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
int cntColor = 0;
int opac = 200;
int color_set[] = new int[21];

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
Location centerLocation = new Location(30, 0); // lat lon
Location havasLocation = new Location(40.722912f, -74.007606f);
Location firstLocation = new Location(41.754586f, -82.127606f);
Location secondLocation = new Location(37.319828f, -26.880493f);

PVector pan_pos = new PVector();  // location info (x -> lon, y -> lat)
PVector pan_tpos = new PVector(); // location info (x -> lon, y -> lat)
int cntStop = 0;
float rate = 0.03f; // for lerp

static public void main(String args[]) {
  Frame frame = new Frame("testing");
  frame.setUndecorated(true);
  // The name "sketch_name" must match the name of your program
  PApplet applet = new followLOVE_131012_pan();
  frame.add(applet);
  applet.init();
  frame.setBounds(0, 0, 1920*2, 1080); 
  frame.setVisible(true);
}

public void setup() {
  /* PROJECTION */
  size(1920*2, 1080, GLConstants.GLGRAPHICS); // 800, 600 // 1920, 1080
  font = createFont("/Users/madscience/Desktop/DROP/SansSerif-48.vlw",48);
  //font = createFont("/Users/madscience/Desktop/DROP/DS-DIGIB.TTF", 32); 
  String connStr = "jdbc:sqlite:" + ("/Users/madscience/Desktop/DROP/basicMap.mbtiles");
  
  /* MONITOR */
//  size(int(1920*0.73), int(540*0.73), GLConstants.GLGRAPHICS);
//  //size(1280,720, GLConstants.GLGRAPHICS);
   //font = createFont("SansSerif-48.vlw", 48);
////  //font = createFont("/Users/youjinshin/Documents/TwitterViz/followLove_131008_pan/data/DS-DIGIB.TTF", 32);
//  String connStr = "jdbc:sqlite:" + ("/Users/youjinshin/Documents/Map/basicMap.mbtiles");

  // unfolding map
  map = new UnfoldingMap(this, new MBTilesMapProvider(connStr));
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setTweening(true);
  map.zoomAndPanTo(centerLocation, 3);
  
  pan_pos.x = 0;
  pan_pos.y = 30;
  pan_tpos.x = 0;
  pan_tpos.y = 30;

  // twitter
  connectTwitter();
  twitter.addListener(listener);
  twitter.filter(new FilterQuery().track(keywords));
  myTweets = new ArrayList();
  myTime = new Time();
  pLocation = havasLocation;
  colorMode(HSB, 360, 100, 100);
  getColor();
}

public void draw() {
  imageMode(CORNER);
  directionalLight(166, 166, 196, -60, -60, -60);
  background(0);
  map.draw();

  if (TwitterOn) { // when new twitter comes
    int tcolor = color_set[cntColor];
    Fireworks f = new Fireworks();
    myFire.add(f);
    
    Tweet t = new Tweet();
    t.myLocation = temp_location;
    t.pLocation = pLocation;
    t.username = username;
    t.tcolor = tcolor;
    t.lat = lat;
    t.lon = lon;
    myTweets.add(t);
    
    StartOn = true;
    cntStop = 0;
    rate = 0.03f;
    cntColor++;
  } else {
    cntStop++;
    if(cntStop % 100 == 0) {
      pan_tpos.x = random(-60, 60);
      pan_tpos.y = random(-30, 30);
      rate = 0.01f;
    }
  }
   
  
  if (StartOn) {
    for (int i = 0; i < myTweets.size(); i++) {
      Tweet t = (Tweet) myTweets.get(i); 
      Fireworks f = (Fireworks) myFire.get(i);
      if (i > 1) {     
        Tweet tp = (Tweet) myTweets.get(i-1);
        if (tp.isDraw == true) t.display(i, f);
        if (t.isDraw == false) {
            pan_tpos.x = t.lon;
            pan_tpos.y = t.lat;
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
  if (cntColor > 10) cntColor = 0;
  TwitterOn = false;
  myTime.display();
  
  //pan_pos.lerp(pan_tpos, rate);
  float dx = pan_tpos.x - pan_pos.x;
  float dy = pan_tpos.y - pan_pos.y;
  pan_pos.x += dx * rate;
  pan_pos.y += dy * rate;
  
  Location target = new Location(pan_pos.y, pan_pos.x);
  map.panTo(target);
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

public void getColor() {
  color_set[0] = color(48, 77, 100, opac);
  color_set[1] = color(198, 66, 65, opac);
  color_set[2] = color(91, 70, 76, opac);
  color_set[3] = color(323, 51, 64, opac);
  color_set[4] = color(18, 84, 98, opac);
  color_set[5] = color(7, 78, 88, opac);
  color_set[6] = color(40, 91, 100, opac);
  color_set[7] = color(192, 82, 84, opac);
  color_set[8] = color(124, 57, 56, opac);
  color_set[9] = color(295, 65, 61, opac);
  color_set[10] = color(32, 80, 99, opac);
  color_set[11] = color(48, 77, 100, opac);
  color_set[12] = color(198, 66, 65, opac);
  color_set[13] = color(91, 70, 76, opac);
  color_set[14] = color(323, 51, 64, opac);
  color_set[15] = color(18, 84, 98, opac);
  color_set[16] = color(7, 78, 88, opac);
  color_set[17] = color(40, 91, 100, opac);
  color_set[18] = color(192, 82, 84, opac);
  color_set[19] = color(124, 57, 56, opac);
  color_set[20] = color(295, 65, 61, opac);
}

class ArcLine {
  int num = 34;
  int cnt = 0;
  int cntB = 0;
  float increment = PI/num;
  float strokeWidth = 0;
  float d = 0;

  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = 0;
  int color_set[] = new int[21];
  int opac = 200;
  int tcolor;
  
  float tempX = 0;
  float tempY = 0;
  int temp_i = 0;
  Location tempPanLocation = new Location(0, 0);
  
  ArcLine() {
    getColor();
  }

  public void display(float x1_, float y1_, float x2_, float y2_, int strokeWidth_, int tcolor_) {
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    strokeWidth = strokeWidth_*0.5f;
    displayArc3D();
    temp_i = strokeWidth_;
    tcolor = tcolor_;
  }

  public void displayArc3D() {
    float d1 = dist(x1, y1, 0, 0);
    float d2 = dist(x2, y2, 0, 0);
    float dia = dist(x1, y1, x2, y2);
    noFill();
    strokeWeight(2);
    //stroke(color_set[temp_i]);
    stroke(tcolor);

    pushMatrix();
      translate(x1, y1);
    pushMatrix();
      float theta = atan2(y2-y1, x2-x1);
      rotateZ(theta);
    pushMatrix();
      rotateX(-PI/2);
      arc(dia/2, 0, dia, dia, PI, PI+increment*cnt);    
      // for panning
      float r = dia/2;
      d = r + r * cos(PI+increment*cnt);
      tempY = y1 + d*sin(theta); // lat
      tempX = x1 + d*cos(theta); // lon  
    popMatrix();  
    popMatrix();
    popMatrix();
    cnt++;
    if (cnt > num)  cnt = num;
  }
  
  public void getColor() {
    color_set[0] = color(48, 77, 100, opac);
    color_set[1] = color(198, 66, 65, opac);
    color_set[2] = color(91, 70, 76, opac);
    color_set[3] = color(323, 51, 64, opac);
    color_set[4] = color(18, 84, 98, opac);
    color_set[5] = color(7, 78, 88, opac);
    color_set[6] = color(40, 91, 100, opac);
    color_set[7] = color(192, 82, 84, opac);
    color_set[8] = color(124, 57, 56, opac);
    color_set[9] = color(295, 65, 61, opac);
    color_set[10] = color(32, 80, 99, opac);
    color_set[11] = color(48, 77, 100, opac);
    color_set[12] = color(198, 66, 65, opac);
    color_set[13] = color(91, 70, 76, opac);
    color_set[14] = color(323, 51, 64, opac);
    color_set[15] = color(18, 84, 98, opac);
    color_set[16] = color(7, 78, 88, opac);
    color_set[17] = color(40, 91, 100, opac);
    color_set[18] = color(192, 82, 84, opac);
    color_set[19] = color(124, 57, 56, opac);
    color_set[20] = color(295, 65, 61, opac);
  }
}
class Fireworks {
  
  ArrayList<Particle> myParticle= new ArrayList();
  float x = 0;
  float y = 0;
  int cnt = 0;
  
  Fireworks() {
    for(int i = 0; i < 200; i ++) {
       Particle p = new Particle();
       myParticle.add(p);
    }
  }
  
  public void update() {
   cnt++; 
   int num = 2;
   if(cnt > num) myParticle.remove(cnt-num);     
  }
  
  public void display() {
    pushMatrix();
    for(int i = 0; i< myParticle.size(); i++) {
       Particle p = myParticle.get(i);
       p.update();
       p.render(); 
    }
    popMatrix();
  }
}
class Particle {
  
  // Fireworks class 
  PVector position;
  PVector velocity;
  PVector acceleration;
  float opac = 200;
  
  
  Particle() {
    position = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }

  public void update() {
    acceleration = new PVector(random(-0.1f, 0.1f), random(-0.1f, 0.1f));    
    acceleration.normalize(); 
    acceleration.mult(0.11f); // number changes -> speed of fireworks
    velocity.add(acceleration);
    position.add(velocity);
    opac = opac - 1.9f;
    if(opac<0) opac = 0;
  }
  
  public void render() {
    fill(random(255), random(255), random(255), opac);
    noStroke();
    ellipse(position.x, position.y, 2, 2);
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
    pushMatrix();
      translate(width*0.8f,height*0.1f,10);
      //translate(width*0.8,height*0.9,10);
      fill(0,180);
      noStroke();
      rect(0,-height*0.048f, width*0.2f, height*0.058f);
      
      translate(width*0.15f,0);
      fill(255);     
      textAlign(RIGHT);
      textFont(font);
      textSize(PApplet.parseInt(height*0.035f));
      text(st, 0, 0); 
      
      fill(210, 24, 51);
      text("FOLLOW", -width*0.10f,0);
      //text("FOLLOW", -width*0.15,0);
      
      fill(3, 55 ,100);
      text("LOVE    ", -width*0.06f, 0);
      
      fill(212, 22, 47,180);
      text("|", -width*0.06f, 0);
    popMatrix();
  }

  public void cal_month() {
    if (mon == 1)  months ="January";
    if (mon == 2)  months ="February";
    if (mon == 3)  months ="March";
    if (mon == 4)  months ="April";
    if (mon == 5)  months ="May";
    if (mon == 6)  months ="June";
    if (mon == 7)  months ="July";
    if (mon == 8)  months ="August";
    if (mon == 9)  months ="September";
    if (mon == 10)  months ="October";
    if (mon == 11)  months ="November";
    if (mon == 12)  months ="December";
  }
  
  public void checkNum() {
    if(h < 10)  sh = "0"+ h;
    else  sh = str(h);
    
    if(m < 10)  sm = "0"+ m;
    else  sm = str(m);
    
    if(s < 10)  ss = "0"+ s;
    else  ss = str(s);
  }
}

class Tweet {
  float x = 0;
  float y = 0;
  int opacity = 180;
  String username = "hi";
  boolean isDraw = false;
  boolean isCircle = false;
  float panX = 0;
  float panY = 0;
  int tI = 0;
  int tcolor;
  float lat = 0;
  float lon = 0;
  
  
  // for arc
  Location pLocation = new Location(40.722912f, -74.007606f);
  ArcLine myArc;

  boolean isClicked = false;
  int temp_i = 0;
  int strokeWidth = 0;
  float opacity_2 = 20;
  Location myLocation;

  Tweet() {
    myArc = new ArcLine();
    getColor();
  }

  public void display(int strokeWidth_, Fireworks myFire_) {
    getPos();
    Fireworks myFire = new Fireworks();
    myFire = myFire_;
    
    havasMarker = new SimplePointMarker(pLocation);
    ScreenPosition havasPos = havasMarker.getScreenPosition(map);
    float havasX = havasPos.x;
    float havasY = havasPos.y;
    strokeWidth = strokeWidth_;

    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y;

    myArc.display(havasX, havasY, x, y, strokeWidth_, tcolor);
    panX = myArc.tempX;
    panY = myArc.tempY;

    if (myArc.cnt > myArc.num-1) {
      isDraw = true;
      pushMatrix();
        strokeWeight(20);
        translate(x, y);
        //drawSpreadNew();
        myFire.display();
      popMatrix();
      noStroke();
    }
  }

  public void drawSpreadNew() { 
    int num = 20;
    float D = map(strokeWidth,0,10,2,34);
    float o = 255/num;
    float d = (D/num);
    float H = 0, S = 0, B = 0;
    
    noStroke();
    fill(57, 18, 100, 100); 
    ellipse(0, 0, 10, 10);
    ellipse(0, 0, 6, 6);

    for (int i = 0; i < num; i++) {
      noFill();
      H = 57;
      S = map(i, 0, num, 0, 60);
      B = map(i, 0, num, 100, 100);
      stroke(H, S, B);
      strokeWeight(1);

      if (i == temp_i) {
        strokeWeight(1.2f);
        stroke(H, S, B);
      } else {
        strokeWeight(1);
        noStroke();
      }
      ellipse(0, 0, d*i, d*i);
    }
    temp_i++;
    if (temp_i > num) temp_i = 0;
    opacity_2 = opacity_2 - 0.8f;
  }
  
  public void getPos() {
    myMarker = new SimplePointMarker(myLocation);
    ScreenPosition myPos = myMarker.getScreenPosition(map);
    x = myPos.x;
    y = myPos.y; 
  }
  


}

}
