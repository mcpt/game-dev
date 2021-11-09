// This program is used to simulate picking up, dragging, and dropping objects

import java.util.ArrayList;
import java.util.List;

// Program main method
void setup() {
  rectMode(CENTER);
  ellipseMode(CENTER);
  size(800, 500);
  loadHeartIcon();
  initDragAndDrop();
  initPath();
  createFirstWave();
}


void draw() {
  background(#add558);    
  drawPath();
  
  drawAllTowers(); // Draw all the towers that have been placed down before
  drawBalloons();
  handleProjectiles();
  drawTrash();
  //changing the color if it is an illegal drop to red
  if (!legalDrop()) {
    drawTowerIcon(x, y, #FF0000); // Draw the current tower (that the user is holding) as red to indicate illegal
  } else {
    drawTowerIcon(x, y, towerColour); // Draw the current tower (that the user is holding)
  }
  
  drawTowerIcon(650, 50, towerColour); // Draw the pick-up tower on the top right
  drawHealthBar();
  dragAndDropInstructions();
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
