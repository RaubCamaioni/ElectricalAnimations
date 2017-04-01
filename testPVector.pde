


double t = 0.0;
double dt = .01;

double currentTime;
double accumulator;

PGraphics pg;

myCircle mC;


void setup() {
  size(500, 500);
  pg = createGraphics(500, 500);

  currentTime = millis();
  accumulator = 0.0;

  mC = new myCircle(width/2, height/2);
}

void draw() {

  double newTime = millis();
  double frameTime = newTime - currentTime ;
  frameTime /= 1000;

  currentTime = newTime;
  accumulator += frameTime;

  printFPS();

  while(accumulator >= dt) {
    t += dt;
    accumulator -= dt;	
  }

  disp();

}

void disp() {
  pg.beginDraw();
  pg.background(255);
  mC.show();
  pg.endDraw();
  image(pg, 0, 0);
}

void printFPS() {
  if(frameCount % 50 == 0) {
    console.log(rameCount / (millis()/1000f));
  }
	
}

void mouseMoved() {
   mC.x = mouseX;
   mC.y = mouseY;
}

class myCircle() {
  float x, y;

  myCircle(float x, float y) {
     this.x = x;
     this.y = y;
  }

  void show() {
    pg.ellipse(this.x, this.y, 10, 10);
  }
}

