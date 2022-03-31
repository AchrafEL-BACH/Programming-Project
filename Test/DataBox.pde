class DataBox extends PApplet {
  private int windowWidth, windowHeight;
  DataPoint spaceObject;
  
  DataBox(DataPoint object){
    this.windowWidth = 300;
    this.windowHeight = 600;
    this.spaceObject = object;
  }
  
  public void settings() {
    size(windowWidth, windowHeight);
  }
  
  public void draw() {
    background(125);
    fill(255);
    rect(0, 0, windowWidth, 200);
    stroke(0);
    fill(100);
    rect(0, 200, windowWidth, 50);
    rect(0, 250, windowWidth, 50);
    rect(0, 300, windowWidth, 50);
    rect(0, 350, windowWidth, 50);
    rect(0, 400, windowWidth, 50);
    rect(0, 450, windowWidth, 50);
    rect(0, 500, windowWidth, 50);
    rect(0, 550, windowWidth, 50);
    fill(0);
    SpaceItem infos = this.spaceObject.getObject();
    textSize(20);
    text("Name:", 15, 220);
    text("Launch Date", 15, 270);
    text("Status:", 15, 320);
    text("State:", 15, 370);
    text("Mass:", 15, 420);
    text("Diameter:", 15, 470);
    text("Perigee:", 15, 520);
    text("Apogee:", 15, 570);
    textSize(15);
    text(infos.get_name(), 25, 240);
    text(infos.get_launchDate().toString(), 25, 290);
    text(infos.get_status(), 25, 340);
    text(infos.get_state(), 25, 390);
    text(infos.get_mass(), 25, 440);
    text(infos.get_diameter()+"", 25, 490);
    text(infos.get_perigee()+"", 25, 540);
    text(infos.get_apogee()+"", 25, 590);
    translate(150,100);
    fill(0);
    rotate((float)spaceObject.angle);
    spaceObject.angle += 0.01;
    if(spaceObject.angle >= 2*PI) spaceObject.angle %= 2*PI;
    circle(0, 0, 70);
    for(int i = 0; i < spaceObject.spikes; i++){
      pushMatrix();
      rotate(2*PI/spaceObject.spikes * i);
      rect(0, 0, 70, 45);
      popMatrix();
    }
    fill(255,0,0);
    rotate(-(float)spaceObject.angle);
    rect(-25, -15, 50, 30);
    fill(0);
    text("Flag", -20, 0);
  }
  
  DataPoint getObject(){
    return this.spaceObject;
  }
  
  void setObject(DataPoint object){
    this.spaceObject = new DataPoint(object);
  }
}
