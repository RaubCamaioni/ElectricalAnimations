PVector pos;
PVector vel;

void setup() {
  size(500, 500);

  pos = new PVector(width/2, height/2);
  vel = new PVector(1, 1);
}

void draw() {
  background(255);
  vel.set(.1*(mouseX-pos.x), .1*(mouseY-pos.y));
  pos.add(vel);
  ellipse(pos.x, pos.y, 10, 10);
}
