class FilteringTool {
  ArrayList<DataPoint> objectList;
  ObjectFilter stateFilter;
  ObjectFilter distanceFilter;
  ObjectFilter launchDateFilter;
  
  FilteringTool(String filePath){
    objectList = new ArrayList();
    String[] lines = loadStrings("gcat10k.tsv");
    for(int i = 1; i < lines.length; i++){
      objectList.add(new DataPoint(lines[i]));
    }
  }
  
  void setStateFilter(String state){
    this.stateFilter = ObjectFilter.stateFilter(state);
  }
  
  void setDistanceFilter(double lower, double upper){
    this.distanceFilter = ObjectFilter.merge(
      ObjectFilter.perigeeFilter(lower),
      ObjectFilter.apogeeFilter(upper)
    );
  }
  
  void setDateFilter(String lower, String upper){
    this.launchDateFilter = ObjectFilter.merge(
      ObjectFilter.launchDateBeforeFilter(lower),
      ObjectFilter.launchDateAfterFilter(upper)
    );
  }
  
  DataPoint[] getFilterResults(){
    return objectList.stream().filter(ObjectFilter.merge(stateFilter, distanceFilter, launchDateFilter)).toArray(DataPoint[]::new);
  }
}
