//-----GLOBAL VARIABLES------

int cooldown = 20;
int framesElapsed = 0;

int currentLevel = 0;
PathGenerator path = new PathGenerator();
ArrayList<Projectile> projectiles = new ArrayList<>();
//
final int rectX = 50;
final int rectY = 50;

final float[][] level1 = {
    
    
    /* DESCRITPION OF STEPS
    
      Basically the number of "steps" taken represents how far along the 
      balloon is in the path.  A balloon with 0 steps taken will be at the start of
      the path, and a balloon with many steps will be further along.  You can also have
      negative steps, which essentially represents a balloon that is off the screen but
      will be by the user on the path seen shortly (Eg. -30 steps means the balloon is 30 steps 
      behind the starting point of the path).  
      
      Speed is also relative to how many steps a balloon takes every time draw() loops.
      A balloon with a speed of 1 will take 1 "step" each time draw() loops, and one 
      with a speed of 2 will take 2 "steps" each time (meaning the second one moves faster)
      
      Steps is used in updatePositions() to control the movement of balloons.  For example,
      if the balloon has taken less than 100 steps, it will move along a horizontal line.
      If it has taken more but less than 200 steos, it will move across a vertical line.
      (See updatePositions())
    */
    
    //{Number of "steps" taken, frames of delay before first step, speed}
    {0,0,6},
    {0,30,6},
    {0,60,6},
    {0,90,3},
    {0,120,4},
    {0,150,3},
    {0,180,4},
    {0,210,6},
    {0,240,4},
    {0,270,3},
    {0,300,6},
    {0,330,12},
};
float lastTarget = 0;
//-----END OF GLOBAL VARIABLES------


//-----FUNCTIONS--------------------

//Updates the position of balloons
void updatePositions(float[] balloonProps){
  /*  
    BalloonProps[0] == X Position of the balloon
    BalloonProps[1] == Y Position of the balloon
    BalloonProps[2] == Total # of steps taken
    BalloonProps[3] == # of steps the balloon takes each time draw() runs
  */
  if (balloonProps[1] == 0) {
    final int RADIUS = 25; //Radius of the balloon
    
    PVector position = path.getLocation(balloonProps[0]);
    balloonProps[0] += balloonProps[2]; //Increases the balloon's total steps by the speed
    
    //Drawing of ballon
    ellipse(position.x, position.y,RADIUS,RADIUS);
  } else {
    balloonProps[1]--;
  }
}

//Rotates tower to face the first initial balloon
void rotateBuilding(float distanceTravelled, boolean targetFound){
  framesElapsed++;
  //Shows which balloon is being tracked
  PVector position = path.getLocation(distanceTravelled);
  
  if (targetFound) {
    line(rectX,rectY,position.x,position.y);
  }
  
  translate(rectX,rectY); //Ensures center of rotation is the tower
  // Angle calculation
  float angle; 
  
  
  if (position.x - rectX <= EPSILON) {
    angle = PI / 2;
  } else {
    float slope = (position.y - rectY) / (position.x - rectX);
    angle = atan(slope);
  }
  
  
  rotate(angle);

  //Tower
  rect(0,0,30,30);
}
//-----END OF FUNCTIONS-------------


void setup(){
  path.add(0, 200);
  path.add(300, 100);
  path.add(200, 100);
  path.add(250, 400);
  path.add(300, 350);
  path.add(350, 450);
  path.add(400, 50);
  path.add(700, 400);
  path.add(200, 450);
  path.add(400, 100);
  path.add(750, 450);
  path.add(100, 200);
  path.add(750, 50);
  path.add(400, 300);
  size(800,500);
  ellipseMode(CENTER);
  rectMode(CENTER);
}


void draw(){
  background(255);
  fill(255);
  path.draw();
  //Iterates through all balloons
  for(int balloonNum = 0; balloonNum < level1.length; balloonNum++){
    updatePositions(level1[balloonNum]);
  }
  
  //float dist = path.shortestDist(new PVector(mouseX, mouseY));
  
  //fill(0);
  //if(dist <= PATH_RADIUS) {
  //  text("Cannot Place", 550, 50);
  //} else {
  //  text("Can Place", 550, 50);
  //}
  //fill(255);
  
  //Tower
  pushMatrix();
  
  //float range = 200;
  //// Finds balloon that has travelled the most that is within this range
  //int index = -1;
  //float mostSteps = 0;
  //for(int i = 0; i < level1.length; i++) {
  //  if (level1[i][0] >= mostSteps) {
  //    PVector location = path.getLocation(level1[i][0]);
  //    if (dist(rectX, rectY, location.x, location.y) <= range) {
  //      index = i;
  //      mostSteps = level1[i][0];
  //    }
  //  }
  //}
  //boolean targetFound = false;
  //if (index != -1) {
  //  lastTarget = level1[index][0];
  //  targetFound = true;
  //}
  
  //rotateBuilding(lastTarget, targetFound);
  popMatrix();
  
  //for(Projectile p: projectiles) p.draw();
  //int iterator = 0;
  
  //while (iterator < projectiles.size()) {
  //  if(projectiles.get(iterator).outOfBounds()) {
  //    projectiles.remove(iterator);
  //  } else iterator++;
  //}
 
}
