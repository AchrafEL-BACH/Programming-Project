class DataPoint{
  SpaceItem object;
  float xpos, ypos;
  double angle, speed;
  double semiMinor, semiMajor;
  double size;
  
  DataPoint(String line){
    object = new SpaceItem(line);
    double apogee = object.get_apogee();
    double perigee = object.get_perigee();
    double diameter = object.get_diameter();
    semiMajor = (apogee+diameter/1000+perigee)/2;
    double focusDistance = apogee - semiMajor;
    semiMinor = Math.sqrt(semiMajor * semiMajor - focusDistance * focusDistance);
    angle = random((float)Math.PI);
    speed = random(4) - 2;
    size = 1000/12742*diameter;
  } //<>//
  
  void move() {
    double newAngle = angle * speed;
    if (newAngle >= 2*Math.PI) {angle = 0; newAngle = 0;}
    xpos = (float) (Math.cos(newAngle) * semiMajor);
    ypos = (float) (Math.sin(newAngle) * semiMinor);
    angle += 0.01;
  }
  
  void draw() {
    fill(color(0));
    circle(width/2 + xpos, height/2 + ypos, 10);
  }
}
