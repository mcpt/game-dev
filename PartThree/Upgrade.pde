//To upgrade towers, click them and their radius will show around them. Click the upgrade button to upgrade the tower to the next level
PVector upgradeLocation = new PVector(150, 50);
void towerClickCheck() {
  if (mousePressed) {
    towerClicked = -1;
  }
  for (int i = 0; i < towers.size(); i++) {
    float xPos = towers.get(i).x, yPos = towers.get(i).y;
    if(pointRectCollision(mouseX, mouseY, xPos, yPos, towerSize) && mousePressed) {
      // Drawing the tower range visually 
      towerClicked = i;
    }
  }
}
void drawRange() {
  if (towerClicked != -1) {
    float xPos = towers.get(towerClicked).x, yPos = towers.get(towerClicked).y;
    int[] data = towerData.get(towerClicked);
    fill(127, 80);
    stroke(127);
    strokeWeight(4);
    ellipseMode(RADIUS);
    ellipse(xPos, yPos, data[towerVision], data[towerVision]);
  }
}
//EDIT THIS FOR UI FOR UPGRADES
void drawUpgrade() {
  strokeWeight(0);
  stroke(0);
  fill(#C364FF);
  rectMode(CENTER);
  rect(upgradeLocation.x, upgradeLocation.y, 25, 25); 
  textSize(12);
  text("Upgrade Here", upgradeLocation.x - 30, upgradeLocation.y - 20);
}
void upgradeCheck() {
  if(pointRectCollision(mouseX, mouseY, upgradeLocation.x, upgradeLocation.y, 25) && mousePressed && towerClicked != -1) {
    int[] temp = towerData.get(towerClicked);
    temp[upgrade]++; currentBalance -= towerPrice[temp[projectileType]] / 2;
    towerData.set(towerClicked, temp);
    println("tower number: " + (towerClicked + 1) + ", upgrade level: " + temp[upgrade]);
  }
}
