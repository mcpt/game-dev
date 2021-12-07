PVector removeLocation = new PVector(150, 100);
void drawRemove() {
  strokeWeight(0);
  stroke(0);
  fill(#FF6481);
  rectMode(CENTER);
  rect(removeLocation.x, removeLocation.y, 25, 25); 
  textSize(12);
  text("Click to Remove", removeLocation.x - 30, removeLocation.y - 20);
}
void removeCheck() {
  if(pointRectCollision(mouseX, mouseY, removeLocation.x, removeLocation.y, 25) && mousePressed && towerClicked != -1) {
    int[] temp = towerData.get(towerClicked);
    currentBalance += temp[upgrade] * towerPrice[temp[projectileType]] / 2;
    int temp1 = towerClicked; towerClicked = -1;
    towerData.remove(temp1); towers.remove(temp1);
  }
}
