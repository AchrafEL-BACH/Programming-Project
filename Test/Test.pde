ArrayList<DataPoint> objects;

void setup(){
  size(1400,1000);
  objects = new ArrayList();
  String[] lines = loadStrings("gcat1k.tsv");
  for(int i = 1; i < lines.length; i++){
    objects.add(new DataPoint(lines[i]));
    print(objects.get(i-1));
  }
}

void draw(){
  background(255);
  fill(color(0,0,255));
  circle(width/2, height/2, 100);
  for(DataPoint object : objects) {
    object.move();
    object.draw();
  }
}
