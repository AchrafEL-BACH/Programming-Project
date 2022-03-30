class SpaceItem {
  String name;
  Date launchDate;
  String status;
  String state;
  int mass;
  double diameter;
  double perigee;
  double apogee;
  
  SpaceItem(String line){
    String[] object = line.split("\t");
    name = object[4];
    status = object[11];
    state = object[14];
    mass = Integer.parseInt(object[18]);
    diameter = parseDouble(object[26].replaceAll(" ", ""));
    perigee = parseDouble(object[32].replaceAll(" ", ""));
    apogee = parseDouble(object[34].replaceAll(" ", ""));
    launchDate = new Date(object[6]);
  }
  
  double parseDouble(String number){
    switch(number){
      case "":
        return -1;
      case "Inf":
        return Double.POSITIVE_INFINITY;
      default:
        return Double.parseDouble(number);
    }
  }
  
  String get_name(){
    return name;
  }
  
  Date get_launchDate(){
    return launchDate;
  }
  
  String get_status(){
    return status;
  }
  
  String get_state(){
    return state;
  }
  
  int get_mass(){
    return mass;
  }
  
  double get_diameter(){
    return diameter;
  }
  
  double get_perigee(){
    return perigee;
  }
  
  double get_apogee(){
    return apogee;
  }
  
  class Date{
    int day;
    String month;
    int year;
    
    Date(String value){
      if(value.equals("")) return;
      String values[] = value.split("\\s+");
      String pseudoYear = values[0];
      if(pseudoYear.endsWith("?")) {
        year = -1 * Integer.parseInt(pseudoYear.substring(0, pseudoYear.length() - 1)); //<>//
      } else {
        year = Integer.parseInt(pseudoYear);
        month = values[1];
        day = Integer.parseInt(values[2]);
      }
    }
    
    String toString(){
      if(year<0) return "Around the year " + year*-1;
      return day + " " + month + " " + year;
    }
  }
}
