class DataBox extends PApplet {
  private int windowWidth, windowHeight;
  DataPoint spaceObject;
  
  DataBox(DataPoint object){
    this.windowWidth = 400;
    this.windowHeight = 700;
    this.spaceObject = object;
  }
  
  public void settings() {
    size(windowWidth, windowHeight);
  }
  
  public void draw() {
    background(125);
    fill(255);
    rect(0, 0, windowWidth, 300);
    stroke(0);
    fill(100);
    rect(0, 300, windowWidth, 50);
    rect(0, 350, windowWidth, 50);
    rect(0, 400, windowWidth, 50);
    rect(0, 450, windowWidth, 50);
    rect(0, 500, windowWidth, 50);
    rect(0, 550, windowWidth, 50);
    rect(0, 600, windowWidth, 50);
    rect(0, 650, windowWidth, 50);
    fill(0);
    SpaceItem infos = this.spaceObject.getObject();
    textSize(20);
    text("Name:", 15, 320);
    text("Launch Date", 15, 370);
    text("Status:", 15, 420);
    text("State:", 15, 470);
    text("Mass:", 15, 520);
    text("Diameter:", 15, 570);
    text("Perigee:", 15, 620);
    text("Apogee:", 15, 670);
    textSize(15);
    text(infos.get_name(), 25, 340);
    text(infos.get_launchDate().toString(), 25, 390);
    text(infos.get_status(), 25, 440);
    text(infos.get_state(), 25, 490);
    text(infos.get_mass(), 25, 540);
    text(infos.get_diameter()+"", 25, 590);
    text(infos.get_perigee()+"", 25, 640);
    text(infos.get_apogee()+"", 25, 690);
    translate(200,150);
    fill(0);
    rotate((float)spaceObject.angle);
    spaceObject.angle += 0.01;
    if(spaceObject.angle >= 2*PI) spaceObject.angle = 0;
    circle(0, 0, 100);
    for(int i = 0; i < spaceObject.spikes; i++){
      pushMatrix();
      rotate(2*PI/spaceObject.spikes * i);
      rect(0, 0, 100, 60);
      popMatrix();
    }
    fill(255,0,0);
    rotate(-(float)spaceObject.angle);
    rect(-30, -15, 60, 30);
    fill(0);
    text("Flag", -20, 0);
  }
  
  void setObject(DataPoint object){
    this.spaceObject = new DataPoint(object);
  }
}
