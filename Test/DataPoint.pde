final boolean DRAW_SPIKES = true;

class DataPoint{
  SpaceItem object;
  float xpos, ypos, center;
  double angle, speed;
  double semiMinor, semiMajor;
  double size;
  int spikes;
  
  DataPoint(String line){
    object = new SpaceItem(line);
    double apogee = object.get_apogee();
    double perigee = object.get_perigee();
    double diameter = object.get_diameter();
    semiMajor = (apogee+diameter/1000+perigee)/2;
    double focusDistance = apogee - semiMajor;
    semiMinor = Math.sqrt(semiMajor * semiMajor - focusDistance * focusDistance);
    center = width/2 + (floor(random(1))*2 - 1) * (float)focusDistance;
    angle = random((float)Math.PI);
    speed = random(4) - 2;
    size = 1000/12742*diameter;
    spikes = floor(random(7)+3);
  }
  
  DataPoint(DataPoint copy){
    this.object = copy.object;
    this.semiMajor = copy.semiMajor;
    this.semiMinor = copy.semiMinor;
    this.spikes = copy.spikes;
    this.angle = copy.angle;
  }
  
  double move() {
    // Calculate squared distance to cursor crosshair 
    double sqrDistance = Math.pow(mouseX - (center+xpos), 2) + Math.pow(mouseY - (height/2+ypos), 2);
    
    // Calculate new position
    double newAngle = angle * speed;
    if (newAngle >= 2*Math.PI) {angle = 0; newAngle = 0;}
    xpos = (float) (Math.cos(newAngle) * semiMajor);
    ypos = (float) (Math.sin(newAngle) * semiMinor);
    angle += 0.01;
    
    return sqrDistance;
  }
  
  void drawOrbit() {
    noFill();
    strokeWeight(0.3);
    stroke(color(200));
    ellipse(center, height/2, (float)semiMajor*2, (float)semiMinor*2);
    noStroke();
  }
  
  void drawObject(boolean dataBox) {
    fill(color(0));
    circle(center + xpos, height/2 + ypos, 5);
    if (DRAW_SPIKES) rectangleSpread(spikes, center + xpos, height/2 + ypos, 5, 3);
  }
  
  void rectangleSpread(int amount, float x, float y, int rectWidth, int rectHeight){
    for(int i = 0; i < amount; i++){
      pushMatrix();
      translate(x, y);
      rotate(2*PI/amount * i);
      rect(0, 0, rectWidth, rectHeight);
      popMatrix();
    }
  }
  
  SpaceItem getObject(){
    return this.object;
  }
}
