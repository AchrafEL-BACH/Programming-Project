class UserPanel extends PApplet {
  DropdownList ddl;
  Slider slider;
  DatePicker dp;
  boolean submitting;
  
  UserPanel(String[] states, int minPerigee, int maxApogee){
    this.ddl = new DropdownList(50,100, 200, 30, 5, states);
    this.slider = new Slider(50, 200, 200, minPerigee, maxApogee);
    this.dp = new DatePicker(50, 250);
    this.submitting = false;
  }
  
  void settings(){
    size(300,400);
  }
  
  String[] getStates(){
    return this.ddl.getStates();
  }
  
  int[] getDistances(){
    return this.slider.getDistances();
  }
  
  String[] getDates(){
    return this.dp.getDates();
  }
  
  boolean isSubmitting(){
    return this.submitting;
  }
  
  void finishSubmitting(){
    this.submitting = false;
  }
  
  void draw(){
    background(255);
    slider.move(mouseX);
    this.slider.draw();
    this.dp.draw();
    this.ddl.draw();
    fill(200, 200, 100);
    rect(100, 350, 100, 30);
    fill(0);
    textSize(40);
    text("Filtering Panel", 30, 50);
    textSize(20);
    text("Filter", 130, 370);
    textSize(12);
  }
  
  void mouseReleased(){
    ddl.click(mouseX, mouseY);
    slider.released();
  }
  
  void mousePressed(){
    if(!ddl.isOpened()) slider.click(mouseX, mouseY);
    if(mouseX >= 100 && mouseX <= 200 && mouseY >= 350 && mouseY <= 380) this.submitting = true;
  }
  
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    int dir = int(e / abs(e));
    ddl.scroll(dir);
    if(!ddl.isOpened()) dp.scroll(-dir, mouseX, mouseY);
  }
  
  class DropdownList{
    int x,y;
    int width, height;
    int itemsShown;
    String[] states;
    ArrayList<String> selectedStates;
    boolean opened;
    int shift;
    //Scrollbar scrollbar;
    
    DropdownList(int x, int y, int width, int height, int itemsShown, String[] o){
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
      this.itemsShown = itemsShown;
      this.states = o;
      this.selectedStates = new ArrayList();
      this.opened = false;
      this.shift = 0;
      //this.scrollbar = new Scrollbar(maxDrop);
    }
    
    void draw(){
      stroke(0);
      fill(150);
      rect(this.x, this.y, this.width, this.height);
      fill(0);
      text("States :", x, y - 10);
      String preview = selectedStates.stream().reduce((a, b) -> a + " / " + b).orElse("");
      if(preview.length() < 38) text(preview, x + 10, y + 15);
      else text(preview.substring(0, 35) + " ...", x + 10, y + 15);
      if(this.opened){
        for(int i = 0; i < itemsShown; i++){
          int newY = this.y + this.height + i * this.height;
          String state = states[shift + i];
          if (selectedStates.contains(state))fill(200); else fill(255);
          rect(this.x, newY, this.width, this.height);
          fill(0);
          text(states[shift + i], this.x + 10, newY + 15);
        }
      }
      noStroke();
    }
    
    boolean isOpened(){
      return this.opened;
    }
    
    void click(int mX, int mY){
      if(mX > this.x && mX < this.x + this.width){
        if(mY > this.y && mY < this.y + this.height){
          this.opened = !this.opened;
        } else if(mY > this.y + this.height && mY < this.y + this.height + itemsShown*this.height && this.opened){
          int relativeY = mY - (this.y + this.height);
          int index = int(relativeY/this.height) + shift;
          String selected = states[index];
          if(selectedStates.contains(selected)) selectedStates.remove(selected);
          else selectedStates.add(selected);
        }
      }
    }
    
    void scroll(int dir){
      shift += dir;
      if(shift < 0) shift = 0;
      else if(shift + itemsShown > states.length) shift -=1;
    }
    
    String[] getStates(){
      return selectedStates.toArray(new String[0]);
    }
  }
  
  class Slider{
    int x, y;
    int width;
    int minDistance, maxDistance;
    float bottom, top;
    boolean holdLeft, holdRight;
    
    Slider(int x, int y, int width, int min, int max){
      this.x = x;
      this.y = y;
      this.width = width;
      this.minDistance = min;
      this.maxDistance = max;
      this.bottom = min;
      this.top = max;
      this.holdLeft = false;
      this.holdRight = false;
    }
    
    void draw(){
      stroke(0);
      strokeWeight(2);
      text("Perigee to Apogee :", x, y - 30);
      line(x, y, x + this.width, y);
      line(x, y - 2, x, y + 2);
      text(minDistance, x - 10, y-10);
      line(x + this.width, y - 2, x + this.width, y + 2);
      text(maxDistance, x+this.width, y-10);
      float relativeMin = map(this.bottom, minDistance, maxDistance, 0, this.width);
      float relativeMax = map(this.top, minDistance, maxDistance, 0, this.width);
      strokeWeight(4);
      line(x + relativeMin, y, x + relativeMax, y);
      circle(x + relativeMin, y, 3);
      text(int(this.bottom), x + relativeMin - 20, y + 15);
      circle(x + relativeMax, y, 3);
      text(int(this.top), x + relativeMax, y + 15);
      strokeWeight(1);
      noStroke();
    }
    
    void move(int mX){
      if(holdLeft){
          float relativeMin = map(this.bottom, minDistance, maxDistance, 0, this.width);
          float offset = mX - (x + relativeMin);
          float relativeOffset = map(offset, 0, this.width, 0, maxDistance - minDistance);
          if(top - (bottom + relativeOffset) >= 100) this.bottom += relativeOffset;
          else this.bottom = this.top - 100;
          if(bottom < minDistance) bottom = minDistance;
      } else if(holdRight){
          float relativeMax = map(this.top, minDistance, maxDistance, 0, this.width);
          float offset = mX - (x + relativeMax);
          float relativeOffset = map(offset, 0, this.width, 0, maxDistance - minDistance);
          if(top + relativeOffset- bottom >= 100) this.top += relativeOffset;
          else this.top = this.bottom + 100;
          if(top > maxDistance) top = maxDistance;
      }
    }
    
    void click(int mX, int mY){
      float relativeMin = map(this.bottom, minDistance, maxDistance, 0, this.width);
      float relativeMax = map(this.top, minDistance, maxDistance, 0, this.width);
      if(mY > this.y - 3 && mY < this.y + 3){
        if(mX > this.x + relativeMin - 3 && mX < this.x + relativeMin + 3 && !holdRight){
          holdLeft = true;
        } else if(mX > this.x + relativeMax - 3 && mX < this.x + relativeMax + 3 && !holdLeft){
          holdRight = true;
        }
      }
    }
    
    void released(){
      this.holdLeft = false;
      this.holdRight = false;
    }
    
    int[] getDistances(){
      return new int[]{int(this.bottom), int(this.top)};
    }
  }
  
  class DatePicker{
    int x,y;
    int fromDay, toDay, maxDay;
    int fromMonth, toMonth;
    int fromYear, toYear;
    int[] monthDays;
    
    DatePicker(int x, int y){
      this.x = x;
      this.y = y;
      this.monthDays = new int[]{31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
      this.fromDay = 1;
      this.toDay = 28;
      this.fromMonth = 1;
      this.toMonth = 12;
      this.fromYear = 1970;
      this.toYear = 2000;
    }
    
    void scroll(int dir, int mX, int mY){
      int maxDayFrom = monthDays[fromMonth - 1] + ((fromMonth==2 && fromYear%4==0) ? 1 : 0);
      int maxDayTo = monthDays[toMonth - 1] + ((toMonth==2 && toYear%4==0) ? 1 : 0);
      
      boolean upper = mY >= y+5 && mY <= y+25;
      boolean lower = mY >= y+25 && mY <= y+45;
      if(mX >= x+45 && mX <= x+75){
        if(upper){
          this.fromDay += dir;
          if(this.fromDay > maxDayFrom) this.fromDay = maxDayFrom;
          else if(this.fromDay < 1) this.fromDay = 1;
        } else if (lower) {
          this.toDay += dir;
          if(this.toDay > maxDayTo) this.toDay = maxDayTo;
          else if(this.toDay < 1) this.toDay = 1;
        }
      } else if(mX >= x+90 && mX <= x+120){
        if(upper){
          this.fromMonth += dir;
          if(this.fromMonth > 12) this.fromMonth = 12;
          else if(this.fromMonth < 1) this.fromMonth = 1;
          
          if(this.fromDay > monthDays[fromMonth - 1]) this.fromDay = monthDays[fromMonth- 1];
        } else if (lower) {
          this.toMonth += dir;
          if(this.toMonth > 12) this.toMonth = 12;
          else if(this.toMonth < 1) this.toMonth = 1;
          
          if(this.toDay > monthDays[toMonth - 1]) this.toDay = monthDays[toMonth- 1];
        }
      } else if(mX >= x+130 && mX <= x+170){
        if(upper){
          this.fromYear += dir;
          if(this.fromYear > 2021) this.fromYear = 2021;
          else if(this.fromYear < 0) this.fromYear = 0;
        } else if (lower) {
          this.toYear += dir;
          if(this.toYear > 2021) this.toYear = 2021;
          else if(this.toYear < 0) this.toYear = 0;
        }
      }
    }
    
    String[] getDates(){
      String[] monthStrings = new String[]{"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
      return new String[]{
        this.fromYear + " " + monthStrings[this.fromMonth - 1] + " " + this.fromDay,
        this.toYear + " " + monthStrings[this.toMonth - 1] + " " + this.toDay
      };
    }
    
    void draw(){
      text("Launch Date :", x, y);
      text("From :", x + 10, y + 20);
      text("To :", x + 10, y + 40);
      textSize(16);
      noFill();
      stroke(0);
      rect(x+45, y+5, 30, 20);
      rect(x+90, y+5, 30, 20);
      rect(x+130, y+5, 40, 20);
      rect(x+45, y+25, 30, 20);
      rect(x+90, y+25, 30, 20);
      rect(x+130, y+25, 40, 20);
      fill(0);
      text(this.fromDay, x + 50, y + 20);
      text(" / " + this.fromMonth, x + 80, y + 20);
      text(" / " + this.fromYear, x + 120, y + 20);
      text(this.toDay, x + 50, y + 40);
      text(" / " + this.toMonth, x + 80, y + 40);
      text(" / " + this.toYear, x + 120, y + 40);
      textSize(12);
    }
  }
}
