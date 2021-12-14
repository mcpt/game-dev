// This program is used to simulate picking up, dragging, and dropping objects

import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
// Program main method
void setup() {
  size(800, 500);
  loadHeartIcon();
  loadSpikeIcon();
  initDragAndDrop();
  initPath();
  createWaves();
}

void draw() {
  background(#add558);
  drawPath();

  drawAllTowers(); // Draw all the towers that have been placed down before
  handleProjectiles();
  drawTrash();
  drawSelectedTowers();
  dragAndDropInstructions();
  
  drawCurrentSpikeIcon();
  displayPowerups();
  drawAllSpikes();
  handleSlowdown();
  handleSpeedBoost();

  if (playingLevel){
    drawBalloons();
  }
  drawHealthBar();
  drawBalanceDisplay();
  drawNextLevelButton();
  
  drawTowerUI();
  /*
  //upgrading towers implementation
  drawUpgrade();
  upgradeCheck();
  
  //removing towers implementation
  drawRemove();
  removeCheck();
  */
  
  towerClickCheck();
  drawRange();
  
  if (health <= 0) {
    drawLostAnimation();
  }
}

// Whenever the user drags the mouse, update the x and y values of the tower
void mouseDragged() {
  if (currentlyDragging != notDragging) {
    dragAndDropLocations[currentlyDragging] = new PVector(mouseX + difX, mouseY + difY);
  }
  if (spikeHeld) {
    spikeLocation = new PVector(mouseX + difX, mouseY + difY);
  }
}

// Whenever the user initially presses down on the mouse
void mousePressed() {
  for (int i = 0; i < towerCount; i++) {
    handlePickUp(i);
  }
  handleSpikePickUp();
  handleSlowdownPress();
  handleSpeedBoostPress();
}

// Whenever the user releases their mouse
void mouseReleased() {
  if (currentlyDragging != notDragging) {
    handleDrop(currentlyDragging);
  }
  currentlyDragging = notDragging;
  
  if (spikeHeld) {
    handleSpikeDrop();
  }
}
