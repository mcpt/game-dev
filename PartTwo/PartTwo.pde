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
  handleProjectiles();
  drawTrash();
  drawSelectedTowers();
  dragAndDropInstructions();

  drawBalloons();
  drawHealthBar();
  drawBalanceDisplay();
  
  if (health <= 0) {
    drawLostAnimation();
  }
}

// Whenever the user drags the mouse, update the x and y values of the tower
void mouseDragged() {
  if (currentlyDragging) {
    dragAndDropLocations[held] = new PVector(mouseX + difX, mouseY + difY);
  }
}

// Whenever the user initially presses down on the mouse
void mousePressed() {
  for (int i = 0; i < towerCount; i++) {
    handlePickUp(i);
  }
}

// Whenever the user releases their mouse
void mouseReleased() {
  if (currentlyDragging) {
    handleDrop();
  }
  currentlyDragging = false;
}
