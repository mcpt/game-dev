// This program is used to simulate picking up, dragging, and dropping objects

import java.util.ArrayList;
import java.util.List;

int x, y, difX, difY, count;
List<PVector> towers; // Towers that are placed down
boolean held; // If the mouse is being held down
boolean within; // If mouse was held down during the previous frame

/*
bounds1 and bounds 2 each store a pair of points. 
every pair with the same index (e.g. bounds1[0] and bounds2[0]) will form a rectangle
this rectangle represents an illegal area for dropping your tower.
*/
List<PVector> bounds1; //the first set of the two points of the rectangle
List<PVector> bounds2; //second set of the two points of the rectangle

//these variables are the trash bin coordinates
int trashX1, trashY1, trashX2, trashY2;

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
  
  trashX1 = 700;
  trashY1 = 130;
  trashX2 = 750;
  trashY2 = 180;
  
  count = 0;
  
  bounds1 = new ArrayList();
  bounds2 = new ArrayList();
  
  fillBounds();
  
  towers = new ArrayList();
}

// Check to see if mouse pointer is within the boundaries of the object
boolean withinBounds() {
  return (mouseX - x) * (mouseX - x) + (mouseY - y) * (mouseY - y) <= 169;
}

//This will fill bounds1 and bounds2
void fillBounds() {
  bounds1.add(new PVector(600, 0));
  bounds2.add(new PVector(800, 200));
  
  bounds1.add(new PVector(0, 200));
  bounds2.add(new PVector(100, 250));
  
  bounds1.add(new PVector(100, 200));
  bounds2.add(new PVector(150, 350));
  
  bounds1.add(new PVector(150, 300));
  bounds2.add(new PVector(500, 350));
  
  bounds1.add(new PVector(500, 250));
  bounds2.add(new PVector(550, 350));
  
  bounds1.add(new PVector(550, 250));
  bounds2.add(new PVector(800, 300));
}

// Will return if a drop is legal by finding the rectangle's corners.
boolean legalDrop() {
  for (int i = 0; i < bounds1.size(); i++) {
    float minX = min(bounds1.get(i).x, bounds2.get(i).x);
    float maxX = max(bounds1.get(i).x, bounds2.get(i).x);
    float minY = min(bounds1.get(i).y, bounds2.get(i).y);
    float maxY = max(bounds1.get(i).y, bounds2.get(i).y);
    if (x >= minX && x <= maxX && y >= minY && y <= maxY) {
      return false;
    }
  }
  return true;
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
  if (legalDrop()) {
    towers.add(new PVector(x, y));
   // Add the tower to the list of placed down towers
    x = 650; y = 50;
    println("Dropped for the " + (++count) + "th time.");
  } else if (trashDrop()) {
    x = 650; y = 50;
    println("Dropped object in trash.");
  }
}

// Will be called whenever a tower is picked up
void handlePickUp() {
  println("Object picked up.");
}
// --------------------------------------------------

// Draw a default tower
void drawTowerIcon(float xPos, float yPos) {
  rect(xPos, yPos, 25, 25); // Draw a simple ellipse as the tower
}

void drawAllTowers() {
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    drawTowerIcon(xPos, yPos);
    text("Tower " + (i+1), xPos - 30, yPos - 20);
  }
}
void drawIllegalArea() {
  for (int i = 0; i < bounds1.size(); i++) {
    rectMode(CORNERS);
    fill(84, 53, 0);
    stroke(84, 53, 0);
    float minX = min(bounds1.get(i).x, bounds2.get(i).x);
    float maxX = max(bounds1.get(i).x, bounds2.get(i).x);
    float minY = min(bounds1.get(i).y, bounds2.get(i).y);
    float maxY = max(bounds1.get(i).y, bounds2.get(i).y);
    rect(minX, minY, maxX, maxY);
    fill(255, 255, 255);
    stroke(255, 255, 255);
    rectMode(CENTER);
  }
}
void drawTrash() {
  rectMode(CORNERS);
  fill(89, 232, 0);
  stroke(89, 232, 0);
  rect(trashX1, trashY1, trashX2, trashY2);
  fill(255, 255, 255);
  stroke(255, 255, 255);
  rectMode(CENTER);
}
void draw() {
  background(100);    
  
  drawIllegalArea();
  
  drawAllTowers(); // Draw all the towers that have been placed down before
  
  drawTrash();
  
  //changing the color if it is an illegal drop to red
  if (!legalDrop()) {
    fill(252, 69, 13);
    stroke(252, 69, 13);
    drawTowerIcon(x, y); // Draw the current tower (that the user is holding) as red to indicate illegal
    fill(255, 255, 255);
    stroke(255, 255, 255);
  } else {
    drawTowerIcon(x, y); // Draw the current tower (that the user is holding)
  }
  
  drawTowerIcon(650, 50); // Draw the pick-up tower on the top right
  
  stroke(255);
  text("Pick up tower from here!", 620, 20);
  text("Brown areas are places where you can't place down towers!", 200, 20);
  text("Place a tower into the green area to put it in the trash.", 200, 40);
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
