/*
Encompasses: Displaying Balloons, Waves & Sending Balloons, Balloon Reaching End of Path
*/

ArrayList<ArrayList<float[]>> levels = new ArrayList<ArrayList<float[]>>();
ArrayList<float[]> balloons;
final int distanceTravelled = 0, delay = 1, speed = 2, hp = 3, slowed = 4, ID = 5;
final int balloonRadius = 25; //Radius of the balloon
final int maxBalloonHP = 50;

int levelNum = -1;
boolean playingLevel = false;

void createWaves() {
  createLevels(2);
  
  //(level balloons are for, number of balloons, first balloon delay, deley between the sequence of balloons, speed, hp)
  createBalloons(0,5,0,20,1,maxBalloonHP);
  createBalloons(0,100,30,20,2,maxBalloonHP);

  createBalloons(1,5,0,20,1,maxBalloonHP);
}

void createLevels(int num){
  for (int i = 0; i < num; i++){
    levels.add(new ArrayList<float[]>());
  }
}

void createBalloons(int level, int numBalloons, float delay, float delayInBetween, float speed, float hp){
  for (int i = 0; i < numBalloons; i++){
    levels.get(level).add(new float[]{0,delay + i * delayInBetween , speed, hp, 0, levels.get(level).size()});
  }
}

// Displays and moves balloons
void updatePositions(float[] balloon) {
  // Only when balloonProps[1] is 0 (the delay) will the balloons start moving.
  if (balloon[delay] < 0) {
    PVector position = getLocation(balloon[distanceTravelled]);
    float travelSpeed = balloon[speed] * slowdownAmount; // Slow down the balloon if the slowdown powerup is engaged
    balloon[distanceTravelled] += travelSpeed; //Increases the balloon's total steps by the speed

    //Drawing of ballon
    ellipseMode(CENTER);
    strokeWeight(0);
    stroke(0);
    fill(0);
    
    //draw healthbar outline
    stroke(0, 0, 0);
    strokeWeight(0);
    rectMode(CORNER);
    fill(#830000);
    final float hbLength = 35, hbWidth = 6;
    rect(position.x - hbLength / 2, position.y - (balloonRadius), hbLength, hbWidth);
    //draw mini healthbar
    noStroke();
    fill(#FF3131);
    rect(position.x - hbLength / 2, position.y - (balloonRadius), hbLength * (balloon[hp] / maxBalloonHP), hbWidth); //the healthbar that changes based on hp
 
    noFill();
  
    //write text
    stroke(0, 0, 0);
    textSize(14);
    fill(255, 255, 255);
    text("Health:   "+health, 670, 462);
    
    fill(#f3cd64);
    if (balloon[slowed] == 1) {
      fill(#C19D40);
    }
    ellipse(position.x, position.y, balloonRadius, balloonRadius);

  } else {
    balloon[delay]-=balloon[speed];
  }
}

void drawBalloons() {
  balloons = levels.get(levelNum);
  for (int i = 0; i < balloons.size(); i++) {
    float[] balloon = balloons.get(i);
    updatePositions(balloon);

    PVector position = getLocation(balloon[distanceTravelled]);
    if (balloonSpikeCollision(position)) {
      handleBalloonPop();
      balloons.remove(i);
      i--;
      continue;
    }
    if (balloon[hp] <= 0) {
      handleBalloonPop();
      balloons.remove(i);
      i--;
      continue;
    }
    if (balloon[distanceTravelled] >= pathLength) {
      balloons.remove(i); // Removing the balloon from the list
      health--; // Lost a life.
      i--; // Must decrease this counter variable, since the "next" balloon would be skipped
      // When you remove a balloon from the list, all the indexes of the balloons "higher-up" in the list will decrement by 1
    }
  }
  if (balloons.size() == 0){
    playingLevel = false;
  }
}

// ------- HP SYSTEM --------
/*
  Heath-related variables:
 int health: The player's total health.
 This number decreases if balloons pass the end of the path (offscreen), currentely 11 since there are 11 balloons.
 PImage heart: the heart icon to display with the healthbar.
 */
int health = 11;  //variable to track user's health
PImage heart;

void loadHeartIcon() {
  heart = loadImage("heart.png");
}
//method to draw a healthbar at the bottom right of the screen
void drawHealthBar() {
  //draw healthbar outline
  stroke(0, 0, 0);
  strokeWeight(0);
  fill(#830000);
  rectMode(CENTER);
  rect(721, 455, 132, 20);
  int trueHealth = max(health, 0);
  //draw healthbar
  noStroke();
  rectMode(CORNER);
  fill(#FF3131);
  rect(655, 445.5, trueHealth*12, 20); //the healthbar that changes based on hp
  rectMode(CENTER);
  noFill();

  //write text
  stroke(0, 0, 0);
  textSize(14);
  fill(255, 255, 255);
  text("Health:   "+trueHealth, 670, 462);

  //put the heart.png image on screen
  imageMode(CENTER);
  image(heart, 650, 456);
  noFill();
}

//Next level Button
boolean pointRectCollision(float x1, float y1, float x2, float y2, float sizeX, float sizeY) {
  //            --X Distance--               --Y Distance--
  return (abs(x2 - x1) <= sizeX / 2) && (abs(y2 - y1) <= sizeY / 2);
}

void drawNextLevelButton(){
  PVector center = new PVector(100,400);
  PVector lengths = new PVector(100,100);
  
  fill(0,150,0);
  if (playingLevel){ 
    fill(0,150,0,100);
  }
  rect(center.x,center.y,lengths.x,lengths.y);
  
  if (!playingLevel && pointRectCollision(mouseX,mouseY,center.x,center.y,lengths.x,lengths.y) && mousePressed && levelNum < levels.size()-1){
    playingLevel = true;
    levelNum++;
  }
}
