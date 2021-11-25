/*
Encompasses: Displaying Towers, Drag & Drop, Discarding Towers, Rotating Towers, Tower Validity Checking
 */
// -------- CODE FOR DRAG & DROP ----------------------

int held = -1; // -1 = not holding any tower, 0 = within default, 1 = within eight, 2 = within slow
boolean currentlyDragging = false;
final int notHeld = -1;
final int def = 0, eight = 1, slow = 2;
final int towerCount = 3;
int difX, difY, count;

int[] towerPrice = {100, 200, 200};
color[] towerColours = {#7b9d32, #F098D7, #82E5F7};
PVector[] originalLocations = {new PVector(650, 50), new PVector(700, 50), new PVector(750, 50)}; // Constant, "copy" array to store where the towers are supposed to be
PVector[] dragAndDropLocations = {new PVector(650, 50), new PVector(700, 50), new PVector(750, 50)}; // Where the currently dragged towers are

ArrayList<PVector> towers; // Towers that are placed down

final int cooldownRemaining = 0, maxCooldown = 1, towerVision = 2, projectileType = 3;
ArrayList<int[]> towerData;

final int towerSize = 25;
final color towerErrorColour = #E30707; // Colour to display when user purchases tower without sufficient funds
//final color 
//these variables are the trash bin coordinates
int trashX1, trashY1, trashX2, trashY2;

ArrayList<Projectile> projectiles = new ArrayList<Projectile>();


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

int[] makeTowerData() {  
  if (held == def) {
    return new int[] {
      10, // Cooldown between next projectile
      10, // Max cooldown
      300, // Tower Vision
      0 // Projectile ID
    };
  } else if (held == eight) {
    return new int[] {
      25, // Cooldown between next projectile
      25, // Max cooldown
      100, // Tower Vision
      1 // Projectile ID
    };
  } else if (held == slow) {
    return new int[] {
      35,
      35,
      100, // Tower Vision
      2
    };
  }
  return new int[] {}; //filler since we need to return something
}

void initDragAndDrop() {
  difX = 0;
  difY = 0;

  trashX1 = 525;
  trashY1 = 30;
  trashX2 = 775;
  trashY2 = 120;

  count = 0;
  towers = new ArrayList<PVector>();
  towerData = new ArrayList<int[]>();
}

// Use point to rectangle collision detection to check for mouse being within bounds of pick-up box
boolean pointRectCollision(float x1, float y1, float x2, float y2, float size) {
  //            --X Distance--               --Y Distance--
  return (abs(x2 - x1) <= size / 2) && (abs(y2 - y1) <= size / 2);
}

boolean withinBounds(int towerID) {
  PVector towerLocation = dragAndDropLocations[towerID];
  return pointRectCollision(mouseX, mouseY, towerLocation.x, towerLocation.y, towerSize);
}

//check if you drop in trash
boolean trashDrop() {
  PVector location = dragAndDropLocations[held];
  if (location.x >= trashX1 && location.x <= trashX2 && location.y >= trashY1 && location.y <= trashY2) return true;
  return false;
}

// -------Methods Used for further interaction-------
void handleDrop() { // Will be called whenever a tower is placed down
  // Instructions to check for valid drop area will go here
  if (trashDrop()) {
    dragAndDropLocations[held] = originalLocations[held];
    println("Dropped object in trash.");
  } else if (legalDrop()) {
    towers.add(dragAndDropLocations[held].copy());
    towerData.add(makeTowerData());
    dragAndDropLocations[held] = originalLocations[held];
    purchaseTower(towerPrice[held]);
    println("Dropped for the " + (++count) + "th time.");
  }
}

// Will be called whenever a tower is picked up
void handlePickUp(int pickedUpTowerID) {
  if (withinBounds(pickedUpTowerID) && hasSufficientFunds(towerPrice[pickedUpTowerID])) {
    held = pickedUpTowerID;
    currentlyDragging = true;
    PVector location = dragAndDropLocations[pickedUpTowerID];
    difX = (int) location.x - mouseX; // Calculate the offset values (the mouse pointer may not be in the direct centre of the tower)
    difY = (int) location.y - mouseY;
  }
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
    int[] data = towerData.get(i);
    int towerType = data[projectileType];
    PVector track = furthestBalloon();
    if (track == null) {
      drawTowerIcon(xPos, yPos, towerColours[towerType]);
    } 
    else {
      drawTowerWithRotation(xPos, yPos, towerColours[towerType], new PVector(track.x, track.y));
    }
    fill(#4C6710);
    textSize(12);
    text("Tower " + (i+1), xPos - 30, yPos - 20);
  }
}
void drawSelectedTowers() {
  // Draws the tower you're dragging
  // Changing the color if it is an illegal drop to red
  if (held != notHeld) {
    if (!legalDrop()) {
      PVector location = dragAndDropLocations[held];
      drawTowerIcon(location.x, location.y, #FF0000);
    } else {
      PVector location = dragAndDropLocations[held];
      drawTowerIcon(location.x, location.y, towerColours[held]);
    }
  }

  // Draws the default towers
  for (int towerType = 0; towerType < towerCount; towerType++) {
    PVector location = originalLocations[towerType];
    if (attemptingToPurchaseTowerWithoutFunds(towerType)) {
      drawTowerIcon(location.x, location.y, towerErrorColour);
    } else drawTowerIcon(location.x, location.y, towerColours[towerType]);
    fill(255);
    textSize(14);
    int textOffsetX = -15, textOffsetY = 26;
    // displays the prices of towers
    text("$" + towerPrice[towerType], location.x + textOffsetX, location.y + textOffsetY);
  }
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
  text("Mouse X: " + mouseX + "\nMouse Y: " + mouseY + "\nMouse held: " + mousePressed + "\nTower Held: " + held, 15, 20);
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

// Will return if a drop is legal by looking at the shortest distance between the rectangle center and the path.
boolean legalDrop() {
  PVector heldLocation = dragAndDropLocations[held];
  // checking if this tower overlaps any of the already placed towers
  for (int i = 0; i < towers.size(); i++) {
    PVector towerLocation = towers.get(i);
    if (pointRectCollision(heldLocation.x, heldLocation.y, towerLocation.x, towerLocation.y, towerSize)) return false;
  }
  return shortestDist(heldLocation) > PATH_RADIUS;
}
