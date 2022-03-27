ArrayList<DataPoint> objects;
PGraphics mask;
PImage canvas, magnified;
DataBox info;
DataPoint closestObject;

void setup(){
  size(1200,1000);
  objects = new ArrayList();
  String[] lines = loadStrings("gcat1k.tsv");
  for(int i = 1; i < lines.length; i++){
    objects.add(new DataPoint(lines[i]));
  }
  surface.setLocation(0,0);
  info = new DataBox(objects.get(0));
  PApplet.runSketch(new String[]{"--location=1200,0", "InfoBox"}, info);
  mask = createGraphics(20,20);
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.smooth();
  mask.circle(10,10,20);
  mask.endDraw();
}

void draw(){
  background(255);
  fill(color(0,0,255));
  circle(width/2, height/2, 20);
  double minDist = Double.POSITIVE_INFINITY;
  for(int i = 0; i < 2; i++) {
    DataPoint object = objects.get(i);
    if(!mousePressed) {
      double dist = object.move();
      if(dist<minDist){
        minDist = dist;
        closestObject = object; //<>//
      }
    }
    object.drawObject(false); //<>//
  }
  canvas = get();
  for(int i = 0; i < 2; i++) { //13 for the circle
    DataPoint object = objects.get(i);
    object.drawOrbit();
  }
  magnified = canvas.get(mouseX - 10, mouseY - 10, 20, 20);
  magnified.mask(mask);
  image(magnified, mouseX - 50, mouseY - 50, 100, 100);
  stroke(125,0,0);
  circle(mouseX, mouseY, 100);
  fill(125,0,0);
  rect(mouseX-10, mouseY-1, 20, 2);
  rect(mouseX-1, mouseY-10, 2, 20);
  noStroke();
}

void mouseReleased(){
  info.setObject(closestObject); //<>//
}
