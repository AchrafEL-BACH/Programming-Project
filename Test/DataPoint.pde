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
    double apogee = object.get_apogee()       /2; //divided by two to be able to render furthest objects
    double perigee = object.get_perigee()     /2;
    double diameter = object.get_diameter();
    semiMajor = (apogee+diameter/1000+perigee)/2;
    double focusDistance = apogee - semiMajor;
    semiMinor = Math.sqrt(semiMajor * semiMajor - focusDistance * focusDistance);
    center = width/2 + (round(random(1))*2 - 1) * (float)focusDistance;
    angle = random((float)Math.PI);
    speed = random(4) - 2;
    size = 1000/12742*diameter; //unused real scale because the items would be to small to render
    spikes = floor(random(7)+3);
  }
  
  DataPoint(DataPoint copy){
    this.object = copy.object;
    this.center = copy.center;
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
  
  void drawOrbit(PGraphics canvas) {
    canvas.noFill();
    canvas.strokeWeight(0.3);
    canvas.stroke(200);
    canvas.ellipse(center, height/2, (float)semiMajor*2, (float)semiMinor*2);
    canvas.strokeWeight(1);
    canvas.noStroke();
  }
  
  void drawSelectedOrbit(){
    noFill();
    strokeWeight(4);
    stroke(255, 100, 255);
    ellipse(center, height/2, (float)semiMajor*2, (float)semiMinor*2);
    strokeWeight(1);
    noStroke();
  }
  
  void drawObject(PGraphics canvas) {
    canvas.fill(color(0));
    canvas.circle(center + xpos, height/2 + ypos, 3);
    if (DRAW_SPIKES) rectangleSpread(spikes, center + xpos, height/2 + ypos, 3, 1, canvas);
  }
  
  void rectangleSpread(int amount, float x, float y, int rectWidth, int rectHeight, PGraphics canvas){
    for(int i = 0; i < amount; i++){
      canvas.pushMatrix();
      canvas.translate(x, y);
      canvas.rotate(2*PI/amount * i);
      canvas.rect(0, 0, rectWidth, rectHeight);
      canvas.popMatrix();
    }
  }
  
  SpaceItem getObject(){
    return this.object;
  }
}
