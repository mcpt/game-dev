/*
Encompasses: Displaying Towers, Drag & Drop, Discarding Towers, Rotating Towers, Tower Validity Checking
*/
// -------- CODE FOR DRAG & DROP ----------------------

int x, y, difX, difY, count;
List<PVector> towers; // Towers that are placed down
boolean held; // If the mouse is being held down
boolean within; // If mouse was held down during the previous frame

//these variables are the trash bin coordinates
int trashX1, trashY1, trashX2, trashY2;

void initDragAndDrop() {
    
  x = 650; y = 50;
  
  held = false;
  within = false;
  difX = 0;
  difY = 0;
  
  trashX1 = 700;
  trashY1 = 130;
  trashX2 = 750;
  trashY2 = 180;
  
  count = 0;
  towers = new ArrayList();
}


// Check to see if mouse pointer is within the boundaries of the tower
boolean withinBounds() {
  return (mouseX - x) * (mouseX - x) + (mouseY - y) * (mouseY - y) <= 13 * 13;
}


//check if you drop in trash
boolean trashDrop() {
  if (x >= trashX1 && x <= trashX2 && y >= trashY1 && y <= trashY2) {
     return true;
  }
  return false;
}

// -------Methods Used for further interaction-------
void handleDrop() { // Will be called whenever a tower is placed down
  // Instructions to check for valid drop area will go here
  if (trashDrop()) {
    x = 650; y = 50;
    println("Dropped object in trash.");
  } else if (legalDrop()) {
    towers.add(new PVector(x, y));
   // Add the tower to the list of placed down towers
    x = 650; y = 50;
    println("Dropped for the " + (++count) + "th time.");
  }  
}

// Will be called whenever a tower is picked up
void handlePickUp() {
  println("Object picked up.");
}
// --------------------------------------------------

// Draw a default tower
void drawTowerIcon(float xPos, float yPos, color colour) {
  strokeWeight(0);
  stroke(0);
  fill(colour);
  rectMode(CENTER);
  rect(xPos, yPos, 25, 25); // Draw a simple rectangle as the tower
}
// Draws a tower that rotates to face the targetLocation
void drawTowerIcon(float xPos, float yPos, color colour, PVector targetLocation) {
  strokeWeight(5);
  stroke(150);
  
  line(xPos, yPos, targetLocation.x, targetLocation.y);
  pushMatrix();
  translate(xPos, yPos);
  
    // Angle calculation
 
  float slope = (targetLocation.y - yPos) / (targetLocation.x - xPos);
  float angle = atan(slope);

  
  rotate(angle);
  
  strokeWeight(0);
  fill(colour);
  rectMode(CENTER);
  rect(0, 0, 25, 25); // Draw a simple rectangle as the tower
  
  popMatrix();
}
void drawAllTowers() {
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    drawTowerIcon(xPos, yPos, 255, new PVector(mouseX, mouseY)); // Towers will track the mouse as a placeholder
    text("Tower " + (i+1), xPos - 30, yPos - 20);
  }
}

void drawTrash() {
  rectMode(CORNERS);
  strokeWeight(0);
  fill(89, 232, 0);
  stroke(89, 232, 0);
  rect(trashX1, trashY1, trashX2, trashY2);
  fill(255, 255, 255);
  stroke(255, 255, 255);
}

void dragAndDropInstructions() {
  
  stroke(255);
  text("Pick up tower from here!", 620, 20);
  text("Brown areas are places where you can't place down towers!", 200, 20);
  text("Place a tower into the green area to put it in the trash.", 200, 40);
  text("Mouse X: " + mouseX + "\nMouse Y: " + mouseY + "\nMouse held: " + held + "\nWithin object bounds: " + within, 50, 50);
}


// -------- CODE FOR PATH COLLISION DETECTION ---------
float pointDistToLine(PVector start, PVector end, PVector point) {
  // Code from https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment 
  float l2 = (start.x - end.x) * (start.x - end.x) + (start.y - end.y) * (start.y - end.y);  // i.e. |w-v|^2 -  avoid a sqrt
  if (l2 == 0.0) return dist(end.x, end.y, point.x, point.y);   // v == w case
  float t = max(0, min(1, PVector.sub(point,start).dot(PVector.sub(end,start)) / l2));
  PVector projection = PVector.add(start, PVector.mult(PVector.sub(end,start),t));  // Projection falls on the segment
  return dist(point.x, point.y, projection.x, projection.y);
}

float shortestDist(PVector point) {
  float answer = Float.MAX_VALUE;
  for (int i = 0; i < points.size() - 1; i++) {
    PVector start = points.get(i);
    PVector end = points.get(i + 1);
    float distance = pointDistToLine(start, end, point);
    answer = min(answer, distance);
  }
  return answer;
}

// Will return if a drop is legal by looking at the shortance distance between the rectangle center and the path.
boolean legalDrop() {
  return shortestDist(new PVector(x, y)) > PATH_RADIUS;
}
