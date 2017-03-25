VectorField vf;
ArrayList<Wire> wires;
ToolBar tool;

double t = 0.0;
double dt = .01;

double currentTime;
double accumulator;

void setup() {
  size(500, 500);
  background(255);

  currentTime = millis();
  accumulator = 0.0;

  vf = new VectorField(25, .1);
  wires = new ArrayList<Wire>();
  tool = new ToolBar();
}

void draw() {
  background(255);

  double newTime = millis();
  double frameTime = newTime - currentTime ;
  frameTime /= 1000;

  if ( frameTime > 0.025 )
      frameTime = 0.025;

  currentTime = newTime;
  accumulator += frameTime;

  while(accumulator >= dt) {
    t += dt;
    accumulator -= dt;
    for(Wire wire : wires) {
      wire.cos(t, dt, 1000);
    }
  }

  update();
  render();
  vf.zeroField();
}

void render() {
  vf.show();
  for(Wire wire : wires) {
    wire.show();
  }
  tool.show();
  vf.show();
}

void update() {
  for(Wire wire : wires) {
    wire.move();
  }

  for(int i = 0; i < vf.size; i++){
    for(int j = 0; j < vf.size; j++) {
      for(Wire wire : wires) {
        wire.mField(vf.getPV(i, j));
      }
    }
  }
}

void mouseClicked() {

  if(tool.addWireIn()) {
    wires.add(new Wire(width/2, height/2, 1000, true));
  }


  if(tool.addWireOut()) {
    wires.add(new Wire(width/2, height/2, 1000, false));
  }

}

void mousePressed() {
  for(Wire wire : wires) {
    if(wire.mouseOver()){
      wire.selected = true;
    }
  }
}

void mouseReleased() {
  for(Wire wire : wires) {
    wire.selected = false;
  }
}
class PointVector extends PVector {

  float px, py;

  PointVector(float px, float py, float x, float y) {
    super(x, y);
    this.px = px;
    this.py = py;
  }

  PVector set(float x, float y) {
     return super.set(x, y);
  }

  PVector add(PVector vec) {
    return super.add(vec);
  }
}
class VectorField {
  private PointVector[][] vf;
  int size;

  VectorField(int size, float padding) {
    this.size = size;
    vf = new PointVector[size][size];

    for(int i = 0; i < vf.length; i++) {
      for(int j = 0; j < vf.length; j++) {
        vf[i][j] = new PointVector( width*padding + i*(width*(1-padding*2))/(vf.length-1),    //x pos
                                    height*padding + j*(height*(1-padding*2))/(vf.length-1),  //y pos
                                    0,                                                        //x vec
                                    10 );                                                     //y vec
      }
    }
  }

  PointVector getPV(int row, int col) {
    return vf[row][col];
  }

  void show() {
    for(int i = 0; i < this.size; i++) {
      for(int j = 0; j < this.size; j++) {
        PointVector pv = vf[i][j];
        line(pv.px, pv.py, pv.px + pv.x, pv.py + pv.y);
        ellipse(pv.px + pv.x, pv.py + pv.y, 2, 2);
      }
    }
  }

  void zeroField() {
    for(int i = 0; i < this.size; i++) {
      for(int j = 0; j < this.size; j++) {
        vf[i][j].set(0, 0);
      }
    }
  }

}
interface Draggable {
  boolean mouseOver();
  void move();
}
class Wire implements Draggable {
  float px, py, mag;
  float freq, phase;
  boolean out;
  boolean selected;

  Wire(float px, float py, float mag, boolean out) {
    this.px = px;
    this.py = py;
    this.mag = mag;
    this.out = out;
    freq = 0;
    phase = 0;
  }

  Wire(float px, float py, float mag, boolean out, float freq, float phase) {
    this.px = px;
    this.py = py;
    this.mag = mag;
    this.out = out;
    this.freq = freq;
    this.phase = phase;
  }

  void mField(PointVector pv) {
    PVector temp = new PVector(pv.px - this.px, pv.py - this.py);
    float dist = temp.mag();
    temp.mult(this.mag/(dist*dist));

    if(temp.mag() > 20) {
      temp.setMag(20);
    }

    if(out) {
      temp.rotate(-HALF_PI);
    }
    else {
      temp.rotate(HALF_PI);
    }

    pv.add(temp);
  }

  void cos(double t, double dt, float mag) {
    this.mag = (float)(mag*Math.cos(2*Math.PI*freq*(t+dt) + phase));
  }

  void setAC(float freq, float phase) {
    this.freq = freq;
    this.phase = phase;
  }

  void show() {
    drawWire(this.px, this.py, this.out);
  }

  void move() {
    if(this.selected) {
      this.px = mouseX;
      this.py = mouseY;
    }
  }

  boolean mouseOver() {
    if(dist(mouseX, mouseY, this.px, this.py) < 20) {
      return true;
    }
    return false;
  }
}

void drawWire(float x, float y, boolean out) {
  ellipseMode(CENTER);
  fill(255);
  ellipse(x, y, 10, 10);

  if(!out) {
    line(x - 2, y - 2, x + 2, y + 2);
    line(x - 2, y + 2, x + 2, y - 2);
  } else {
    fill(0);
    ellipse(x, y, 2, 2);
  }
}
class ToolBar {

  float wireInX, wireInY;
  float wireOutX, wireOutY;

  ToolBar() {
    wireInX = width/2 - 20;
    wireInY = 20;
    wireOutX = width/2 + 20;
    wireOutY = 20;
  }

  void show() {
    drawToolBox();
    drawWire(wireInX, wireInY, true);
    drawWire(wireOutX, wireOutY, false);
  }

  void drawToolBox() {
    strokeWeight(2);
    fill(255);
    rect(0, 0, width, 40);
    strokeWeight(1);
    fill(0);
  }

  boolean addWireIn() {
    if(dist(mouseX, mouseY, wireInX, wireInY) < 15) {
      return true;
    }
    return false;
  }

  boolean addWireOut() {
    if(dist(mouseX, mouseY, wireOutX, wireOutY) < 15) {
      return true;
    }
    return false;
  }
}
