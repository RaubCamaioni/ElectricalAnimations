
VectorField v;
Wire[] wires;

float pad = .1;

void setup() {
  size(400, 400);
  
  v = new VectorField(20);
  wires = new Wire[1];
  wires[0] = new Wire(width/2, height/2, 10, "in");
  
  for(int i = 0; i < v.size; i++) {
    for(int j = 0; j < v.size; j++) {
      v.vec[i][j].x = width*pad + i*(width*(1-pad*2))/(v.size-1);
      v.vec[i][j].y = height*pad + j*(height*(1-pad*2))/(v.size-1);
    }
  }
      
}

void draw() {
  background(255, 255, 255);
  
  for(int i = 0; i < v.size; i++) {
    for(int j = 0; j < v.size; j++) {
      v.vec[i][j].show();
    }
  }
  
  for(int i = 0; i < wires.length; i++)
    wires[i].show();
    
  v.wireField(wires);
}

void mouseMoved() {
  wires[0].x = mouseX;
  wires[0].y = mouseY;
}class VectorField {
 
 Vector[][] vec;
 int size;
  
 VectorField(int size) {
   this.size = size;
   vec = new Vector[size][size];
   
   for(int i = 0; i < size; i++) 
     for(int j = 0; j < size; j++) 
       vec[i][j] = new Vector(); 
 }
 
 Vector getVec(int row, int col) {
   return vec[row][col];
 }
 
 /*
 *  We need a more robust vector handler. Need to be able to ad vectors together and get resulting vectors;
 *
 */
 void wireField(Wire[] wires) {
   for(int i = 0; i < size; i++) 
     for(int j = 0; j < size; j++) {
       
       Vector v = vec[i][j];
       
       for(int k = 0; k < wires.length; k++) {
         float disX = v.x - wires[k].x;
         float disY = wires[k].y - v.y;
         float disM = (float)Math.sqrt(Math.pow(disX, 2)+Math.pow(disY, 2));  
  
         v.mag = 1000/disM;
         
         if(v.mag > 30) {
           v.mag = 30; 
         }
         
         if(disX == 0) {
           if(disY > 0) {
             v.ang = -90; 
           }else {
             v.ang = 90;
           }
         }else if(disY == 0) {
           if(disX > 0) {
             v.ang = 0; 
           }else {
             v.ang = 180;
           }
           
         }else {
           float slope = disY/disX;
           v.ang = (float)(Math.atan(-slope)*180/Math.PI);
           
           if((disX < 0 && disY < 0) || (disX < 0 && disY > 0))
             v.ang += 180;
         }
         
         if(wires[k].flow.equals("in")) {
            v.ang += 180; 
         }
       }
     }
 }
 
}class Vector {
 float x;
 float y;
 float mag;
 float ang;
  
  Vector(float x, float y, float mag, float ang) {
    this.x = x;
    this.y = y;
    this.mag = mag;
    this.ang = ang;
  }
  
  Vector() {
    this.x = 0;
    this.y = 0;
    this.mag = 10;
    this.ang = 0; //random(1)*360;
  }
  
  void show() {
    stroke(0, 0, 0);
    float endX = (float)(this.x + this.mag*Math.sin(ang*Math.PI/180));
    float endY = (float)(this.y - this.mag*Math.cos(ang*Math.PI/180));
    line(this.x, this.y, endX, endY);
    ellipse(endX, endY, 2, 2);
  }
  
  void add(Vector vec) {
    float x1 = this.mag*sin(this.ang);
    float y1 = this.mag*cos(this.ang);
    
    float x2 = vec.mag*sin(this.ang);
    float y2 = vec.mag*cos(this.ang);
    
    this.mag = (float)Math.sqrt(Math.pow((x1+x2), 2) + Math.pow((y1+y2), 2));
    this.ang = 0;
  }
}class Wire {
 
  String flow;
  float mag;
  float x, y;
  
  Wire(float x, float y, float mag, String flow) {
    this.flow = flow;
    this.mag = mag;
    this.x = x;
    this.y = y;
  }
  
  void show() {
    ellipseMode(CENTER);
    fill(255);
    ellipse(this.x, this.y, 10, 10);
    
    if(flow.equals("in")) {  
      line(this.x - 5, this.y - 5, this.x + 5, this.y + 5);
      line(this.x - 5, this.y + 5, this.x + 5, this.y - 5);
    } else {
      fill(0);
      ellipse(this.x, this.y, 2, 2);
    }
  }  
  
}