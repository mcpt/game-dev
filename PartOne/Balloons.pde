/*
Encompasses: Displaying Balloons, Waves & Sending Balloons, Balloon Reaching End of Path
*/

ArrayList<float[]> balloons = new ArrayList<>();
final int distanceTravelled = 0, delay = 1, speed = 2, hp = 3;
final int balloonRadius = 25; //Radius of the balloon

void createFirstWave() {
//{Number of "steps" taken, frames of delay before first step, speed}
  balloons.add(new float[]{0, 100, 3, 50});
  balloons.add(new float[]{0, 130, 3, 50});
  balloons.add(new float[]{0, 160, 2, 50});
  balloons.add(new float[]{0, 220, 4, 50});
  balloons.add(new float[]{0, 340, 2, 50});
  balloons.add(new float[]{0, 370, 2, 50});
  balloons.add(new float[]{0, 400, 5, 50});
  balloons.add(new float[]{0, 430, 5, 50});
  balloons.add(new float[]{0, 490, 3, 50});
  balloons.add(new float[]{0, 520, 1, 50});
  balloons.add(new float[]{0, 550, 3, 50});
}

// Displays and moves balloons
void updatePositions(float[] balloon) {
  // Only when balloonProps[1] is 0 (the delay) will the balloons start moving.
  if (balloon[delay] == 0) {

    PVector position = getLocation(balloon[distanceTravelled]);
    balloon[distanceTravelled] += balloon[speed]; //Increases the balloon's total steps by the speed

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
    rect(position.x - hbLength / 2, position.y - (balloonRadius), hbLength * (balloon[hp] / 50), hbWidth); //the healthbar that changes based on hp
 
    noFill();
  
    //write text
    stroke(0, 0, 0);
    textSize(14);
    fill(255, 255, 255);
    text("Health:   "+health, 670, 462);
    
    fill(#f3cd64);
    ellipse(position.x, position.y, balloonRadius, balloonRadius);

  } else {
    balloon[delay]--;
  }
}

void drawBalloons() {
  for (int i = 0; i < balloons.size(); i++) {
    float[] balloon = balloons.get(i);
    updatePositions(balloon);
    if (balloon[hp] <= 0) {
      balloons.remove(i);
      i--;
      continue;
    }
    if (atEndOfPath(balloon[distanceTravelled])) {
      balloons.remove(i); // Removing the balloon from the list
      health--; // Lost a life.
      i--; // Must decrease this counter variable, since the "next" balloon would be skipped
      // When you remove a balloon from the list, all the indexes of the balloons "higher-up" in the list will decrement by 1
    }
  }
}

// Similar code to distance along path
boolean atEndOfPath(float travelDistance) {
  float totalPathLength = 0;
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    float distance = dist(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
    totalPathLength += distance;
  }
  if (travelDistance >= totalPathLength) return true; // This means the total distance travelled is enough to reach the end
  return false;
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

  //draw healthbar
  noStroke();
  rectMode(CORNER);
  fill(#FF3131);
  rect(655, 445.5, health*12, 20); //the healthbar that changes based on hp
  rectMode(CENTER);
  noFill();

  //write text
  stroke(0, 0, 0);
  textSize(14);
  fill(255, 255, 255);
  text("Health:   "+health, 670, 462);

  //put the heart.png image on screen
  imageMode(CENTER);
  image(heart, 650, 456);
  noFill();
}
