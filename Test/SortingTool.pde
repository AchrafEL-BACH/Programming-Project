import java.util.Comparator;

public interface SortingTool extends Comparator<DataPoint>{
  Comparator<SpaceItem> compareByName = Comparator.comparing(SpaceItem::get_name, (o1, o2) -> o1.toLowerCase().compareTo(o2.toLowerCase()));
  Comparator<SpaceItem> compareByState = Comparator.comparing(SpaceItem::get_state, (o1, o2) -> o1.compareTo(o2));
  Comparator<SpaceItem> compareByDate = Comparator.comparing(SpaceItem::get_launchDate, (o1, o2) -> o1.compareTo(o2));
  Comparator<SpaceItem> compareByPerigee = Comparator.comparing(SpaceItem::get_perigee, (o1, o2) -> (new Double(o1)).compareTo(new Double(o2)));
  Comparator<SpaceItem> compareByApogee = Comparator.comparing(SpaceItem::get_apogee, (o1, o2) -> (new Double(o1)).compareTo(new Double(o2)));
  ArrayList<Comparator<SpaceItem>> comparators = new ArrayList(){
    {
      add(compareByName);
      add(compareByState); 
      add(compareByDate);
      add(compareByPerigee); 
      add(compareByApogee);
    }  
  };
  
  static final int NAME = 0;
  static final int STATE = 1;
  static final int DATE = 2;
  static final int PERIGEE = 3;
  static final int APOGEE = 4;
  
  static Comparator<DataPoint> sortBy(int... keys){
    Comparator<DataPoint> comparator = Comparator.comparing(DataPoint::getObject, comparators.get(keys[0]));
    for(int i = 1; i < keys.length; i++){
      comparator = comparator.thenComparing(DataPoint::getObject, comparators.get(keys[i]));
    }
    return comparator;
  }
  
  static Comparator<DataPoint> test(){
    Comparator<DataPoint> comparator = Comparator.comparing(DataPoint::getObject, comparators.get(0))
    .thenComparing(DataPoint::getObject, comparators.get(3))
    .thenComparing(DataPoint::getObject, comparators.get(4));
    return comparator;
  }
}
