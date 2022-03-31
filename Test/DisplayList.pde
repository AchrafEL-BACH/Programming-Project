class DisplayList extends PApplet {
  PGraphics listImage;
  int listHeight;
  DataPoint[] objects;
  Scrollbar sb;

  void settings() {
    size(300, 1000);
  }

  DisplayList(DataPoint[] objects, PGraphics image) {
    setList(objects, image);
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
    int scrollValue = sb.scrollValue();
    image(listImage.get(0, scrollValue, width, height), 0, 0, width, height);
    sb.move();
    sb.draw();
  }
  
  void mousePressed(){
    sb.pressed();
  }
  
  void mouseReleased(){
    sb.released();
  }
  
  void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    sb.scrolled(e, -1);
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
