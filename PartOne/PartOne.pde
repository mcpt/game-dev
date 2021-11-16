// This program is used to simulate picking up, dragging, and dropping objects

import java.util.ArrayList;
import java.util.List;

// Program main method
void setup() {
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
  drawSelectedTowers();
  dragAndDropInstructions();

  drawBalloons();
  drawHealthBar();
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
  within = withinBounds(); // Check to see if the pointer is within the bounds of the tower

  if (within) {
    handlePickUp(); // The tower has been "picked up"
    difX = x - mouseX; // Calculate the offset values (the mouse pointer may not be in the direct centre of the tower)
    difY = y - mouseY;
  }
}

// Whenever the user releases their mouse
void mouseReleased() {
  if (within) { // If the user was holding the tower in the previous frame, the tower has just been dropped
    handleDrop(); // Call the method to handle the drop and check for drop validity
  }

  within = false; // The mouse is no longer holding the tower
}
