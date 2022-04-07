class FilteringTool {
  ArrayList<DataPoint> objectList;
  ObjectFilter stateFilter;
  ObjectFilter distanceFilter;
  ObjectFilter launchDateFilter;
  
  ArrayList<String> stateList;
  double minDistance, maxDistance;
  
  FilteringTool(String filePath){
    objectList = new ArrayList();
    stateList = new ArrayList();
    minDistance = Double.POSITIVE_INFINITY;
    maxDistance = 0;
    String[] lines = loadStrings("gcat10k.tsv");
    for(int i = 1; i < lines.length; i++){
      DataPoint newObject = new DataPoint(lines[i]);
      objectList.add(newObject);
      String state = newObject.getObject().get_state();
      if(!stateList.contains(state)) stateList.add(state);
      double perigee = newObject.getObject().get_perigee();
      if(perigee < minDistance) minDistance = perigee;
      double apogee = newObject.getObject().get_apogee();
      if(apogee > maxDistance) maxDistance = apogee;
    }
  }
  
  String[] getStateList(){
    return stateList.toArray(new String[0]);
  }
  
  int getMinDistance(){
    return (int)minDistance;
  }
  
  int getMaxDistance(){
    return (int)maxDistance;
  }
  
  void setStateFilter(String... states){
    this.stateFilter = ObjectFilter.stateFilter(states);
  }
  
  void setDistanceFilter(double lower, double upper){
    this.distanceFilter = ObjectFilter.merge(
      ObjectFilter.perigeeFilter(lower),
      ObjectFilter.apogeeFilter(upper)
    );
  }
  
  void setDateFilter(String lower, String upper){
    this.launchDateFilter = ObjectFilter.merge(
      ObjectFilter.launchDateAfterFilter(lower),
      ObjectFilter.launchDateBeforeFilter(upper)
    );
  }
  
  DataPoint[] getFilterResults(){
    return objectList.stream().filter(ObjectFilter.merge(stateFilter, distanceFilter, launchDateFilter)).toArray(DataPoint[]::new);
  }
}
