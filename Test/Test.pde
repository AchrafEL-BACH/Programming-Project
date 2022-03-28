ArrayList<DataPoint> objects;
PGraphics mask, canvas;
PImage orbits, magnified;
boolean released;
DataBox info;
DataPoint closestObject;

final int OBJECTS_SHOWN = 10000;
final int WINDOW_WIDTH = 1200;
final int WINDOW_HEIGHT = 1000;

void settings(){
  size(WINDOW_WIDTH,WINDOW_HEIGHT);
}

void setup(){
  objects = new ArrayList();
  String[] lines = loadStrings("gcat10k.tsv");
  for(int i = 1; i < lines.length; i++){
    objects.add(new DataPoint(lines[i]));
  }
  surface.setLocation(0,0);
  info = new DataBox(objects.get(0));
  PApplet.runSketch(new String[]{"--location=1200,0", "InfoBox"}, info);
  canvas = createGraphics(WINDOW_WIDTH, WINDOW_HEIGHT);
  mask = createGraphics(20,20);
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.smooth();
  mask.circle(10,10,20);
  mask.endDraw();
  
  background(255);
  for(int i = 0; i < OBJECTS_SHOWN; i++) {
    DataPoint object = objects.get(i);
    object.drawOrbit(false);
  }
  orbits = get();
}

void draw(){
  image(orbits, 0, 0);
  fill(color(0,0,255));
  circle(width/2, height/2, 20);
  info.getObject().drawOrbit(true);
  double minDist = Double.POSITIVE_INFINITY;
  canvas.beginDraw();
  canvas.clear();
  for(int i = 0; i < OBJECTS_SHOWN; i++) {
    DataPoint object = objects.get(i);
    if(!mousePressed) {
      double dist = object.move();
      if(dist<minDist){
        minDist = dist;
        closestObject = object; //<>//
      }
    }
    object.drawObject(canvas); //<>//
  }
  canvas.endDraw();
  if (released) {
    info.setObject(closestObject);
    released = false;
  }
  image(canvas, 0, 0);
  magnified = canvas.get(mouseX - 10, mouseY - 10, 20, 20);
  alternateMask(magnified, mask);
  image(magnified, mouseX - 50, mouseY - 50, 100, 100);
  stroke(125,0,0);
  noFill();
  circle(mouseX, mouseY, 100);
  fill(125,0,0);
  rect(mouseX-10, mouseY-1, 20, 2);
  rect(mouseX-1, mouseY-10, 2, 20);
  noStroke();
}

void mouseReleased(){
  released = true; //Goes through a boolean intermediate because one more cycle is needed before the method launch //<>//
}

//Source: https://github.com/processing/processing/issues/1738. Problem with the mask making an opaque black circle.
void alternateMask(PImage target, PGraphics mask) { 
  target.loadPixels();
  mask.loadPixels();
  for (int i = 0; i < mask.pixels.length; i++) {
    float originalAlpha = alpha(target.pixels[i]);
    if (originalAlpha != 0) {
      target.pixels[i] = ((mask.pixels[i] & 0xff) << 24) | (target.pixels[i] & 0xffffff);
    }
  }
  target.updatePixels();
}
