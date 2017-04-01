double t = 0.0;
double dt = .01;

double currentTime;
double accumulator;

void setup() {
  size(500, 500);

  currentTime = millis();
  accumulator = 0.0;
}

void draw() {

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
  }
}

