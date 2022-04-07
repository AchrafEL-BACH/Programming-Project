class DisplayList extends PApplet {
  boolean displayMode;
  
  // Attributes needed for the displayScreen
  PGraphics listImage;
  int listHeight;
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
    this.listImage = image;
    sb.scrolled(0, index);
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
          text(order, 220, 160);
          fill(110);
        }else{
          fill(255);
        }
        rect(10, 100 + i * 100, 200, 100);
        fill(0);
        text(attribute, 30, 170 + i * 100);
      }
    }
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
  
  void mousePressed(){
    if (displayMode){
      sb.pressed();
      if(mouseX>=250 && mouseX <= 280 && mouseY >= 0 && mouseY <= 30) displayMode = false;
    } else {
      int panelSize = attributes.size() * 100;
      if(mouseX>=10 && mouseX <= 210 && mouseY >= 100 && mouseY <= 100 + panelSize){
        String attribute = attributes.get(floor((mouseY - 100)/panelSize));
        if(selectedAttributes.contains(attribute)) selectedAttributes.remove(attribute);
        else selectedAttributes.add(attribute);
      }
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
