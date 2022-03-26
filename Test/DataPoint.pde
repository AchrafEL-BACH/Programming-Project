class DataPoint{
  SpaceItem object;
  int xpos, ypos;
  
  DataPoint(String line){
    object = new SpaceItem(line);
  }
}
