DataPoint[] objects;
DataPoint closestObject;
PGraphics mask, canvas, listImage;
PImage orbits, magnified;
boolean released;
DataBox info;
DisplayList list;

final int OBJECTS_SHOWN = 1000;
final int WINDOW_WIDTH = 1200;
final int WINDOW_HEIGHT = 1000;

void settings(){
  size(WINDOW_WIDTH,WINDOW_HEIGHT);
}

void setup(){
  surface.setLocation(0,0);
  
  // Magnifying Glass mask to make it round and beautiful
  mask = createGraphics(20,20);
  mask.beginDraw();
  mask.background(0);
  mask.noStroke();
  mask.fill(255);
  mask.smooth();
  mask.circle(10,10,20);
  mask.endDraw();
  
  //Filter test
  FilteringTool ft= new FilteringTool("gcat10k.tsv");
  ft.setStateFilter("SU");
  ft.setDistanceFilter((double)200, (double)400);
  ft.setDateFilter("1973 Jan 01", "1971 Jan 01");
  objects = ft.getFilterResults();
  objects = Arrays.stream(objects).sorted((o1, o2) -> o1.getObject().get_name().toLowerCase().compareTo(o2.getObject().get_name().toLowerCase())).toArray(DataPoint[]::new);
  
  // Display of the objects' orbit (base layer of the canvas)
  background(255);
  /*for(int i = 0; i < OBJECTS_SHOWN; i++) {
    DataPoint object = objects.get(i);*/
  for(DataPoint object : objects){
    object.drawOrbit(false);
  }
  orbits = get();
  
  // Display of the objects (second layer of the canvas)
  canvas = createGraphics(WINDOW_WIDTH, WINDOW_HEIGHT);
  
  // Filter window commands
  PApplet filter = new PApplet();
  filter.setSize(300, 400);
  PApplet.runSketch(new String[]{"--location=1200,600", "FilterBox"}, filter);
  
  // Object list window commands
  listImage = drawList(objects);
  list = new DisplayList(objects, drawSelected(0, listImage.get()));
  PApplet.runSketch(new String[]{"--location=1500,0", "DisplayList"}, list);
  
  // InfoBox window commands
  info = new DataBox(new DataPoint(objects[0]));
  PApplet.runSketch(new String[]{"--location=1200,0", "InfoBox"}, info); //<>//
}
 //<>//
void draw(){
  image(orbits, 0, 0);
  fill(color(0,0,255));
  circle(width/2, height/2, 20);
  DataPoint selected = info.getObject();
  selected.drawOrbit(true);
  double minDist = Double.POSITIVE_INFINITY;
  canvas.beginDraw();
  canvas.clear();
  /*for(int i = 0; i < OBJECTS_SHOWN; i++) {
    DataPoint object = objects.get(i);*/
  for(DataPoint object : objects){
    if(!mousePressed) {
      double dist = object.move();
      if(dist<minDist){
        minDist = dist;
        closestObject = object; //<>//
      }
    }
    object.drawObject(canvas); //<>//
  }
  canvas.endDraw(); //<>//
  if (released) {
    info.setObject(closestObject);
    released = false;
    
    int index = Arrays.asList(objects).indexOf(closestObject);
    list.setSelected(index, drawSelected(index, listImage));
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

PGraphics drawList(DataPoint[] objects){
  PGraphics listImage = createGraphics(300, objects.length * 50);
  listImage.beginDraw();
  listImage.stroke(0);
  for (int i = 0; i < objects.length; i++) {
    int y = i * 50;
    SpaceItem si = objects[i].getObject();
    listImage.fill(255);
    listImage.rect(0, y, 250, 50);
    listImage.fill(0);
    listImage.text(si.get_name()+" ("+si.get_state()+")", 10, y + 10);
    listImage.text(si.get_launchDate().toString(), 170, y + 10);
    listImage.text("Orbit(km): "+si.get_perigee()+" - "+si.get_apogee(), 30, y + 25);
    listImage.text("Diameter(m): "+si.get_diameter(), 30, y + 35);
    listImage.text("Mass(kg): "+si.get_mass(), 30, y + 45);
  }
  listImage.noStroke();
  listImage.endDraw();
  return listImage;
}

PGraphics drawSelected(int index, PImage source) {
  PGraphics newImage = createGraphics(source.width, source.height);
  newImage.beginDraw();
  newImage.loadPixels();
  arrayCopy(source.pixels, newImage.pixels);
  newImage.updatePixels();
  newImage.stroke(255, 0, 0);
  newImage.noFill();
  newImage.rect(0, index * 50, 250, 50);
  newImage.noStroke();
  newImage.endDraw();
  return newImage;
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
