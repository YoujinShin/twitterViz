
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

UnfoldingMap map;
SimplePointMarker myMarker;
SimplePointMarker havasMarker;

float lon = 0;
float lat = 0;
float r = 5;
float theta = 0;
int num = 0;

Location centerLocation = new Location(30, 0); // lat ldong
Location havasLocation = new Location(40.722912, -74.007606);
Location firstLocation = new Location(41.754586, -82.127606);
Location secondLocation = new Location(37.319828, -26.880493);
Location panLocation = centerLocation;

void setup() {
  size(1400, 700, GLConstants.GLGRAPHICS);
  smooth();

  // unfolding map
  String connStr = "jdbc:sqlite:" + ("/Users/youjinshin/Documents/Map/basicMap.mbtiles");
//  String connStr = "jdbc:sqlite:" + ("/Users/madscience/Desktop/DROP/basicMap.mbtiles");
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
  map.zoomAndPanTo(centerLocation,2);
  colorMode(HSB, 360, 100, 100);
}

void draw() {
  imageMode(CORNER);
//  directionalLight(166, 166, 196, -60, -60, -60);
  background(0);
  map.draw();

  noStroke();
  fill(0, 180);
  rect(0, 0, width, height);
  
//  lon = lon + 0.4;
//  lat = lat + 0.4;
  lat = r * cos(theta);
  lon = r * sin(theta);
  
  theta = theta + 0.022;
  
  Location tempLocation = new Location(lat, lon);
  map.zoomAndPanTo(tempLocation, 4);
  
  if(lon > 179) {
    lon = -179;
  }
}

