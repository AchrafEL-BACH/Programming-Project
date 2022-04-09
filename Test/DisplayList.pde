class DisplayList extends PApplet {
  boolean displayMode;
  boolean submitting;
  
  // Attributes needed for the displayScreen
  PGraphics listImage;
  int listHeight;
  int selectedIndex;
  DataPoint[] objects;
  Scrollbar sb;
  
  // Attributes needed for the sortingScreen
  ArrayList<String> attributes;
  ArrayList<String> selectedAttributes;

  void settings() {
    size(300, 1000);
  }

  DisplayList(DataPoint[] objects, PGraphics image) {
    setList(objects, image);
    this.displayMode = true;
    this.submitting = false;
    
    this.attributes = new ArrayList(){
      {add("Name"); add("State"); add("Date"); add("Perigee"); add("Apogee");}
    };
    this.selectedAttributes = new ArrayList();
  }

  void setList(DataPoint[] newObjects, PGraphics image) {
    this.objects = newObjects;
    this.listHeight = objects.length * 50;
    this.listImage = image;
    this.sb = new Scrollbar(listHeight);
  }
  
  void setSelected(int index, PGraphics image) {
    this.selectedIndex = index;
    this.listImage = image;
    sb.scrolled(0, index);
  }
  
  void drawSortButton(int x, int y){
    noFill();
    stroke(0);
    rect(x, y, 30, 30);
    fill(0);
    triangle(x + 2, y + 2, x + 28, y + 2, x + 14, y + 28);
    rect(x + 10, y + 28, 9, -10);
    noStroke();
    textSize(14);
    text("Sort", x + 3, y + 45);
  }
  
  boolean isSubmitting(){
    return this.submitting;
  }
  
  int[] finishSubmitting(){
    this.submitting = false;
    if(this.displayMode) return new int[]{selectedIndex};
    else return selectedAttributes.stream().mapToInt(att -> attributes.indexOf(att)).toArray();
  }
  
  boolean getDisplayMode(){
    return this.displayMode;
  }
  
  void setDisplayMode(){
    this.displayMode = true;
    this.selectedAttributes.clear();
  }

  void draw() {
    background(255);
    if (displayMode){
      int scrollValue = sb.scrollValue();
      image(listImage.get(0, scrollValue, width, height), 0, 0, width, height);
      sb.move();
      sb.draw();
      fill(255,0,0);
      drawSortButton(250, 0);
    } else {
      fill(0);
      textSize(70);
      text("Sort by :", 5, 70);
      int attributeCount = this.attributes.size();
      textSize(50);
      stroke(0);
      for(int i = 0; i < attributeCount; i++){
        String attribute = attributes.get(i);
        boolean selected = selectedAttributes.contains(attribute);
        if(selected){
          fill(0);
          int order = selectedAttributes.indexOf(attribute) + 1;
          text(order, 220, 160 + i * 100);
          fill(110);
        }else{
          fill(255);
        }
        rect(10, 100 + i * 100, 200, 100);
        fill(0);
        text(attribute, 30, 170 + i * 100);
      }
      rect(50, 900, 120, 50);
      fill(255);
      text("Sort", 60, 940);
      stroke(0);
      rect(90, 800, 170, 50);
      noStroke();
      fill(0);
      text("Return", 100, 840);
    }
  }
  
  void mousePressed(){
    if (displayMode){
      sb.pressed();
      if(mouseX>=250 && mouseX <= 280 && mouseY >= 0 && mouseY <= 30) displayMode = false;
      else if(mouseX>=0 && mouseX < 250 && mouseY >=0 && mouseY <= height){
        int scrollValue = sb.scrollValue();
        this.selectedIndex = floor((mouseY + scrollValue)/50);
        this.submitting = true;
      }
    } else {
      int panelSize = attributes.size() * 100;
      if(mouseX>=10 && mouseX <= 210 && mouseY >= 100 && mouseY <= 100 + panelSize){
        String attribute = attributes.get(floor((mouseY - 100)/100));
        if(selectedAttributes.contains(attribute)) selectedAttributes.remove(attribute);
        else selectedAttributes.add(attribute);
      } else if(mouseX>=70 && mouseX <= 190 && mouseY >= 900 && mouseY <= 950) this.submitting = true;
      else if(mouseX>=90 && mouseX <= 260 && mouseY >= 800 && mouseY <= 850) this.displayMode = true;
    }
  }
  
  void mouseReleased(){
    if (displayMode){
      sb.released();
    }
  }
  
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if(displayMode){
      sb.scrolled(e, -1);
    }
  }


  class Scrollbar {
    float posx, posy, offset;
    float barHeight, canvasHeight;
    boolean hold = false;

    Scrollbar(float canvasHeight) {
      posx = 280;
      posy = 0;
      this.canvasHeight = canvasHeight;
      barHeight = 1000 / canvasHeight * 1000;
    }

    void move() {
      if (hold) {
        posy = mouseY - offset;
        if (posy < 0) posy = 0;
        else if (posy + barHeight > height) posy = height-barHeight;
      }
    }

    void draw() {
      strokeWeight(1);
      stroke(0);
      fill(210);
      rect(posx, 0, 20, height);
      fill(hold ? 100 : 160);
      rect(posx, posy, 20, barHeight);
      noStroke();
    }

    void pressed() {
      if (mouseX >= posx && mouseX <= posx+20 && mouseY >= posy && mouseY <= posy+barHeight) {
        hold = true;
        offset = mouseY-posy;
      }
    }

    void released() {
      hold = false;
    }
    
    void scrolled(float scroll, float position) {
      float v = map(50, 0, canvasHeight - height, 0, height-barHeight);
      if (position < 0) {
        posy += v * int(scroll / abs(scroll));
        posy = round(posy/v) * v;
      } else {
        posy = v * position;
      }
      if(posy<0) posy = 0;
      else if(posy+barHeight>height) posy=height-barHeight;
    }

    int scrollValue() {
      return (int)map(posy, 0, height-barHeight, 0, canvasHeight - height);
    }
  }
}
