final ArrayList<ArrayList<GridAngle>> grid = new ArrayList<ArrayList<GridAngle>>();

final int xOff = 100;
final int yOff = 100;
final int spacing = 24;
final float rez = 0.002;
final int numLines = 1200;
final int lineLength = 50;
final float segmentLength = 4;

class GridAngle {
  int x, y, r;
  float angle;

  PVector v;

  GridAngle(int x_, int y_, int r_, float angle_) {
    x = x_;
    y = y_;

    angle = angle_;
    r = 1;
    v = new PVector(x + r * cos(angle),
                    y + r * sin(angle));
  }

  void display() {
    
    strokeWeight(2);
    stroke(0);
    //line(x, y, v.x, v.y);
  }
}


void drawFlowLine() {
  GridAngle fa = grid.get((int)random(grid.size())).get((int)random(grid.size()));

  beginShape();
  
  PVector vec = new PVector(fa.x + 1 *cos(fa.angle),
    fa.y + 1 * sin(fa.angle));

  //PVector vec = fa.v;

  curveVertex(vec.x, vec.y);

  float minDist = Float.MAX_VALUE;
  float dist = 0.0;
  int nearestX = 0;
  int nearestY = 0;
  GridAngle tempFA;

  for (int n = 0; n<lineLength; n++) {
    for (int x = 0; x<grid.size(); x++) {
      for (int y = 0; y<grid.get(0).size(); y++) {
        tempFA = grid.get(x).get(y);
        dist = (float)dist(vec.x, vec.y, tempFA.x, tempFA.y);

        if (dist<minDist) {
          minDist = dist;
          nearestX = x;
          nearestY = y;
        }
      }
    }

    minDist = Float.MAX_VALUE;
    float angle = grid.get(nearestX).get(nearestY).angle;

    vec = new PVector(vec.x + segmentLength*cos(angle),
                      vec.y + segmentLength*sin(angle));
                      
    float R = map(sin(radians(frameCount)), -1, 1, 0, 128);
    float G = map(sin(radians(frameCount) + 45), -1, 1, 0, 128);
    float B = map(sin(radians(frameCount) + 90), -1, 1, 0, 128);                      
                      
    stroke(R, G, B);
    
    curveVertex(vec.x, vec.y);

  }
  endShape();
}


void createGrid() {
  for (int x = -xOff; x<width+xOff; x+=spacing) {
    ArrayList<GridAngle> row  = new ArrayList<GridAngle>();
    for (int y = -yOff; y<width+yOff; y+=spacing) {
      float angle = map(noise(x*rez, y*rez), 0.0, 1.0, 0.0, TAU);

      row.add(new GridAngle(x, y, spacing/2, angle));
    }
    grid.add(row);
  }
}

void setup(){
  size(1280,720, P3D);
  noFill();
  createGrid();
}

void draw() {
  
    float red = map(sin(radians(frameCount)), -1, 1, 192, 255);
    float green = map(sin(radians(frameCount) + 45), -1, 1, 192, 255);
    float blue = map(sin(radians(frameCount) + 90), -1, 1, 192, 255);  
  
  background(red, green, blue);
  
  for (int x = 0; x<grid.size(); x++) {
    for (int y = 0; y<grid.get(0).size(); y++) {
      grid.get(x).get(y).display();
    }
  }

  for (int n = 0; n < numLines; n++) {
    drawFlowLine();
  }

}
