ArrayList<DataPoint> objects;

void setup(){
  size(600,600);
  objects = new ArrayList();
  String[] lines = loadStrings("gcat1k.tsv");
  for(int i = 1; i < lines.length; i++){
    objects.add(new DataPoint(lines[i]));
    print(objects.get(i-1));
  }
}
