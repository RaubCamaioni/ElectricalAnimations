PVector pos;
PVector vel;

void setup() {
	size(500, 500);
	background(255);
	pos = new PVector(width, height);
	vel = new PVector(0, 0;
}

void draw() {
	background(255);
	vel = new PVector(.1*(mouseX - pos.x), .1*(mouseY - pos.y));
	pos.add(vel);

	ellipse(pos.x, pos.y, 10, 10);
}

