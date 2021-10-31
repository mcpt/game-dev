// This program is used to simulate picking up, dragging, and dropping objects

import java.util.ArrayList;
import java.util.List;

int x, y, difX, difY, count;
List<PVector> towers; // Towers that are placed down
boolean held; // If the mouse is being held down
boolean within; // If mouse was held down during the previous frame

// Program main method
void setup() {
  x = 650; y = 50;
  rectMode(CENTER);
  ellipseMode(CENTER);
  size(800, 500);
  
  held = false;
  within = false;
  difX = 0;
  difY = 0;
  
  count = 0;
  
  towers = new ArrayList();
}

// Check to see if mouse pointer is within the boundaries of the object
boolean withinBounds() {
  return (mouseX - x) * (mouseX - x) + (mouseY - y) * (mouseY - y) <= 169;
}

// -------Methods Used for further interaction-------
  void handleDrop() { // Will be called whenever a tower is placed down
  towers.add(new PVector(x, y)); // Add the tower to the list of placed down towers
  x = 650; y = 50;
  println("Dropped for the " + (++count) + "th time.");
}

// Will be called whenever a tower is picked up
void handlePickUp() {
  println("Object picked up.");
}
// --------------------------------------------------

// Draw a default tower
void drawTowerIcon(float xPos, float yPos) {
  ellipse(xPos, yPos, 25, 25); // Draw a simple ellipse as the tower
}

void drawAllTowers() {
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    drawTowerIcon(xPos, yPos);
    text("Tower " + (i+1), xPos - 30, yPos - 20);
  }
}

void draw() {
  background(100);     
  drawAllTowers(); // Draw all the towers that have been placed down before
  drawTowerIcon(x, y); // Draw the current tower (that the user is holding)
  drawTowerIcon(650, 50); // Draw the pick-up tower on the top right
  
  stroke(255);
  text("Pick up tower from here!", 620, 20);
  text("Mouse X: " + mouseX + "\nMouse Y: " + mouseY + "\nMouse held: " + held + "\nWithin object bounds: " + within, 50, 50);
  
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
    x = mouseX + difX;
    y = mouseY + difY;
  }
}

// Whenever the user initially presses down on the mouse
void mousePressed() {
  held = true;
  within = withinBounds(); // Check to see if the pointer is within the bounds of the tower
  
  if (within) {
    handlePickUp(); // The tower has been "picked up"
    difX = x - mouseX; // Calculate the offset values (the mouse pointer may not be in the direct centre of the tower)
    difY = y - mouseY;
  }
}
