import java.util.function.Predicate;
import java.util.Arrays;

public interface ObjectFilter extends Predicate<DataPoint> {
  
  static ObjectFilter stateFilter(String state){
    return object -> (object.getObject().get_state().equals(state));
  }
  
  static ObjectFilter perigeeFilter(Double perigee){
    return object -> (object.getObject().get_perigee() >= perigee);
  }
  
  static ObjectFilter apogeeFilter(Double apogee){
    return object -> (object.getObject().get_apogee() <= apogee);
  }
  
  static ObjectFilter launchDateBeforeFilter(String date){
    return object -> (object.getObject().get_launchDate().isBefore(date));
  }
  
  static ObjectFilter launchDateAfterFilter(String date){
    return object -> (object.getObject().get_launchDate().isAfter(date));
  }
  
  static ObjectFilter merge(ObjectFilter... objectFilters) {
    return object -> Arrays.stream(objectFilters).filter(o -> o != null).allMatch(filter -> filter.test(object)); //<>//
  }
}
