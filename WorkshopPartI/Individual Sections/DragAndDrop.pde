import java.util.List;
import java.util.ArrayList;

// Variables for Drag and Drop
int curTowerX, curTowerY; // The coordinates of the centre of the currently held tower
int difX, difY; // The distance between the mouse pointer and the centre of the current held tower
int count; // Temporary debug counter variable
List<PVector> towers; // Towers that are placed down
boolean held; // If the mouse is being held down
boolean within; // If mouse was held down during the previous frame
final int pickupX = 750, pickupY = 60; // The coordinates of the pick-up location


void setup() {
  rectMode(CENTER);
  ellipseMode(CENTER);
  
  size(800, 500);
  setupDragAndDrop();
}

void drawBackground() {
  // Temporary Background
  background(100);
}

void setupDragAndDrop() {
  held = false;
  within = false;
  difX = 0;
  difY = 0;
  curTowerX = pickupX; curTowerY = pickupY;
  
  count = 0;
  towers = new ArrayList();
}

// Checking to see if mouse pointer is within the boundaries of the object
// or to check if picking up is valid (e.g. does the user have enough money to purchase the tower?)
boolean withinBounds() {
  return Math.abs(mouseX - curTowerX) <= 13 && Math.abs(mouseY - curTowerY) <= 13; // Use the difference in x and y from the centre of the square to check for bounds
}

// Will be called whenever a tower is placed down
void handleDrop() {
  
  /* Instructions to check for valid drop area will go here */
  
  towers.add(new PVector(curTowerX, curTowerY)); // Add the tower to the list of placed down towers
  curTowerX = pickupX; curTowerY = pickupY; // Place the tower back into the pick-up position
  println("Dropped for the " + (++count) + "th time.");
}

// Will be called whenever a tower is picked up
void handlePickUp() {
  println("Object picked up.");
}

// Draw a tower at centre location (xPos, yPos)
// To be customized later on (a simple shape will do for now)
void drawTowerIcon(float xPos, float yPos) {
  rect(xPos, yPos, 25, 25); // Draw a simple square as the tower
}

// Used to draw all the towers that were already dropped into the map
void drawAllTowers() {
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    drawTowerIcon(xPos, yPos);
    text("Tower " + (i+1), xPos - 30, yPos - 20);
  }
}

void draw() {
  drawBackground();
  
  // Drag and Drop
  drawAllTowers(); // Draw all the towers that have been placed down before
  drawTowerIcon(curTowerX, curTowerY); // Draw the current tower (that the user is holding)
  drawTowerIcon(pickupX, pickupY); // Draw the pick-up tower on the top right
  
  text("Pick up tower from here!", pickupX - 100, pickupY - 25);
  text("Debug messages:\nMouse X: " + mouseX + "\nMouse Y: " + mouseY + "\nMouse held: " + held + "\nWithin object bounds: " + within, 50, 50);
  
  // Check to see if the mouse was released
  if (!mousePressed) {
    if (held && within) { // If the mouse was held down in the previous frame, the object has just been dropped
      handleDrop(); // Call the method to handle the drop
    }
    
    // Set the previous held frame to false for the next frame call
    held = false;
    within = false;
  }
  
}


// Whenever the user drags the mouse, update the x and y values of the tower
void mouseDragged() {
  if (within) { // Check to see if the user is currently dragging a tower
    // Set the values while accounting for the offset
    curTowerX = mouseX + difX;
    curTowerY = mouseY + difY;
  }
}

// Whenever the user initially presses down on the mouse
void mousePressed() {
  held = true;
  within = withinBounds(); // Check to see if the pointer is within the bounds of the tower
  
  if (within) {
    handlePickUp(); // The tower has been "picked up"
    difX = curTowerX - mouseX; // Calculate the offset values (the mouse pointer may not be in the direct centre of the tower)
    difY = curTowerY - mouseY;
  }
}
