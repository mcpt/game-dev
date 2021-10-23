import java.util.List;
import java.util.ArrayList;

ArrayList<PVector> enemyLocation;
ArrayList<Float> enemySpeed;
final PVector enemyStartLocation = new PVector(0, 0); // Add values to this 
int framesElapsed;

// Variables for Drag and Drop
int curTowerX, curTowerY, difX, difY, count;
List<PVector> towers; // Towers that are placed down
boolean held; // If the mouse is being held down
boolean within; // If mouse was held down during the previous frame

void setup() {
  enemyLocation = new ArrayList();
  enemySpeed = new ArrayList();
  
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
  curTowerX = 650; curTowerY = 50;
  
  count = 0;
  towers = new ArrayList();
}

void spawnWaves() {
  framesElapsed++; 
  // use this value to check for what needs to be spawned
}

void createEnemy(float speed) {
  
}

PVector nextLocation(PVector currentLocation, float speed) {
  return null; // Not implemented yet!
}

void drawEnemy(PVector currentlocation) {
}

// Checking to see if mouse pointer is within the boundaries of the object
boolean withinBounds() {
  return (mouseX - curTowerX) * (mouseX - curTowerX) + (mouseY - curTowerY) * (mouseY - curTowerY) <= 169;
}

// Will be called whenever a tower is placed down
void handleDrop() {
  towers.add(new PVector(curTowerX, curTowerY)); // Add the tower to the list of placed down towers
  curTowerX = 650; curTowerY = 50;
  println("Dropped for the " + (++count) + "th time.");
}

// Will be called whenever a tower is picked up
void handlePickUp() {
  println("Object picked up.");
}

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
  drawBackground();
  spawnWaves();
  for (int i = 0; i < enemyLocation.size(); i++) {
    PVector currentLocation = enemyLocation.get(i);
    float speed = enemySpeed.get(i);
    PVector nextLocation = nextLocation(currentLocation, speed);
    enemyLocation.set(i, nextLocation);
    
    drawEnemy(nextLocation);
  }
  
  // Drag and Drop
  drawAllTowers(); // Draw all the towers that have been placed down before
  drawTowerIcon(curTowerX, curTowerY); // Draw the current tower (that the user is holding)
  drawTowerIcon(650, 50); // Draw the pick-up tower on the top right
  
  text("Pick up tower from here!", 620, 20);
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
