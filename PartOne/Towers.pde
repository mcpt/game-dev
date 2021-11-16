/*
Encompasses: Displaying Towers, Drag & Drop, Discarding Towers, Rotating Towers, Tower Validity Checking
 */
// -------- CODE FOR DRAG & DROP ----------------------

int x, y, difX, difY, count;
ArrayList<PVector> towers; // Towers that are placed down

boolean within; // If mouse was held down during the previous frame
final int towerSize = 25;
final color towerColour = #7b9d32;
//these variables are the trash bin coordinates
int trashX1, trashY1, trashX2, trashY2;

int framesElapsed = 0;
ArrayList<Projectile> projectiles = new ArrayList<>();

PVector furthestBalloon() {
  float maxDist = 0;
  PVector location = null;
  for(float[] balloon: balloons) {
     if(balloon[distanceTravelled] > maxDist) {
       location = getLocation(balloon[distanceTravelled]);
       maxDist = balloon[distanceTravelled];
     }
  }
  return location;
}

void handleProjectiles() {
  framesElapsed++;
  for(PVector tower: towers) {
    if (framesElapsed % 5 == 0) {
      PVector balloon = furthestBalloon();
      if(balloon == null) return;
      PVector toMouse = new PVector(balloon.x - tower.x, balloon.y - tower.y); 
      PVector unitVector = PVector.div(toMouse, toMouse.mag());
      projectiles.add(new Projectile(tower, unitVector.mult(12), 0.25, 2)); 
    }
  }
  for(int i = 0; i < projectiles.size(); i++) {
    Projectile p = projectiles.get(i);
    p.draw();
    if (p.dead()) {
      projectiles.remove(i);
      i--;
    }
  }
}
void initDragAndDrop() {

  x = 650;
  y = 50;

  within = false;
  difX = 0;
  difY = 0;

  trashX1 = 525;
  trashY1 = 30;
  trashX2 = 775;
  trashY2 = 120;

  count = 0;
  towers = new ArrayList<PVector>();
}

// Use point to rectangle collision detection to check for mouse being within bounds of pick-up box
boolean pointRectCollision(float x1, float y1, float x2, float y2, float size) {
  //            --X Distance--               --Y Distance--
  return (abs(x2 - x1) <= size / 2) && (abs(y2 - y1) <= size / 2);
}
// Check to see if mouse pointer is within the boundaries of the tower
boolean withinBounds() {
  return pointRectCollision(mouseX, mouseY, x, y, towerSize);
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
    x = 650;
    y = 50;
    println("Dropped object in trash.");
  } else if (legalDrop()) {
    towers.add(new PVector(x, y));
    // Add the tower to the list of placed down towers
    x = 650;
    y = 50;
    println("Dropped for the " + (++count) + "th time.");
  }
}

// Will be called whenever a tower is picked up
void handlePickUp() {
  println("Object picked up.");
}
// --------------------------------------------------

// Draw a simple tower at a specified location
void drawTowerIcon(float xPos, float yPos, color colour) {
  strokeWeight(0);
  stroke(0);
  fill(colour);
  rectMode(CENTER);
  rect(xPos, yPos, towerSize, towerSize); // Draw a simple rectangle as the tower
}
// Draws a tower that rotates to face the targetLocation
void drawTowerWithRotation(float xPos, float yPos, color colour, PVector targetLocation) {
  strokeWeight(5);
  stroke(#4C6710);

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
  rect(0, 0, towerSize, towerSize); // Draw a simple rectangle as the tower

  popMatrix();
}
void drawAllTowers() {
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    PVector track = furthestBalloon();
    if (track == null) drawTowerIcon(xPos, yPos, towerColour);
    else drawTowerWithRotation(xPos, yPos, towerColour, new PVector(track.x, track.y)); // Towers will track the mouse as a placeholder
    fill(#4C6710);
    text("Tower " + (i+1), xPos - 30, yPos - 20);
  }
}
void drawSelectedTowers() {
  // Draws the tower in the top right and the tower you drag
  // Changing the color if it is an illegal drop to red
  if (!legalDrop()) {
    drawTowerIcon(x, y, #FF0000); // Draw the current tower (that the user is holding) as red to indicate illegal
  } else {
    drawTowerIcon(x, y, towerColour); // Draw the current tower (that the user is holding)
  }

  drawTowerIcon(650, 50, towerColour); // Draw the pick-up tower on the top right
}

void drawTrash() {
  rectMode(CORNERS);
  noStroke();
  fill(#4C6710);
  rect(trashX1, trashY1, trashX2, trashY2);
  fill(255, 255, 255);
  stroke(255, 255, 255);
}

void dragAndDropInstructions() {
  fill(#4C6710);
  textSize(12);

  text("Pick up tower from here!", 620, 20);
  text("You can't place towers on the path of the balloons!", 200, 20);
  text("Place a tower into the surrounding area to put it in the trash.", 200, 40);
  text("Mouse X: " + mouseX + "\nMouse Y: " + mouseY + "\nMouse held: " + mousePressed + "\nWithin object bounds: " + within, 15, 20);
}


// -------- CODE FOR PATH COLLISION DETECTION ---------
float pointDistToLine(PVector start, PVector end, PVector point) {
  // Code from https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
  float l2 = (start.x - end.x) * (start.x - end.x) + (start.y - end.y) * (start.y - end.y);  // i.e. |w-v|^2 -  avoid a sqrt
  if (l2 == 0.0) return dist(end.x, end.y, point.x, point.y);   // v == w case
  float t = max(0, min(1, PVector.sub(point, start).dot(PVector.sub(end, start)) / l2));
  PVector projection = PVector.add(start, PVector.mult(PVector.sub(end, start), t));  // Projection falls on the segment
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
  // checking if this tower overlaps any of the already placed towers
  for (int i = 0; i < towers.size(); i++) {
    PVector towerLocation = towers.get(i);
    if (pointRectCollision(x, y, towerLocation.x, towerLocation.y, towerSize)) return false;
  }
  return shortestDist(new PVector(x, y)) > PATH_RADIUS;
}
