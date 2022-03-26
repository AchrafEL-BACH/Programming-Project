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
    launchDate = new Date(object[6]);
    status = object[11];
    state = object[14];
    mass = Integer.parseInt(object[18]);
    diameter = parseDouble(object[26].replaceAll(" ", ""));
    perigee = parseDouble(object[32].replaceAll(" ", ""));
    apogee = parseDouble(object[34].replaceAll(" ", ""));
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
      print(value);
      String values[] = value.split("");
      day = Integer.parseInt(values[0]);
      month = values[1];
      year = Integer.parseInt(values[2]);
    }
    
    String toString(){
      return "";
    }
  }
}
