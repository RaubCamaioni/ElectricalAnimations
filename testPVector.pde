


double t = 0.0;
double dt = .01;

double currentTime;
double accumulator;

PGraphics pg;

void setup() {
  size(500, 500);
  pg = createGraphics(500, 500);

  currentTime = millis();
  accumulator = 0.0;
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
  pg.endDraw();
}


void printFPS() {
  if(frameCount % 50 == 0) {
    println(frameCount / (millis()/1000f));
  }
	
}

