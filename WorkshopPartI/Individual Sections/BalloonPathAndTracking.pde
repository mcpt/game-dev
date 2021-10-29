//-----GLOBAL VARIABLES------

int currentLevel = 0;

//
float angle;
float slope;
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
    
    //{X-Postion, Y-Position, Number of "steps" taken, speed}
    {0,200,0,2},
    {-30,200,-30,2},
    {-60,200,-60,2},
    {-90,200,-90,1.5},
    {-120,200,-120,2},
    {-150,200,-150,1.5},
    {-180,200,-180,2},
    {-210,200,-210,3},
    {-240,200,-240,2},
    {-270,200,-270,1.5},
    {-300,200,-300,3},
    {-330,200,-330,1.5},
};
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
  
  final int RADIUS = 25; //Radius of the balloon
  
  balloonProps[2] += balloonProps[3]; //Increases the balloon's total steps by the number of steps taken each time draw() runs 
  
  //This if-block checks how many steps the balloon has taken and alters its trajectory accordingly
  if (balloonProps[2] < 100){
    balloonProps[0]+=balloonProps[3];
  }
  else if (balloonProps[2] < 200){
    balloonProps[1]+=balloonProps[3];
  }
  else if (balloonProps[2] < 300){
    balloonProps[0]+=balloonProps[3];
  }
  else if (balloonProps[2] < 400){
    balloonProps[1]-=balloonProps[3];
  }
  else{
    balloonProps[0]+=balloonProps[3];
  }
  
  //Drawing of ballon
  ellipse(balloonProps[0],balloonProps[1],RADIUS,RADIUS);
}

//Rotates tower to face the first initial balloon
void rotateBuilding(float[] balloonProps){
  
  //Shows which balloon is being tracked
  line(rectX,rectY,balloonProps[0],balloonProps[1]);
  
  translate(rectX,rectY); //Ensures center of rotation is the tower
  
  //Angle calculation
  slope = (balloonProps[1]-rectY)/(balloonProps[0]-rectX);
  angle = atan(slope);
  
  rotate(angle);
  
  //Tower
  rect(0,0,30,30);
}
//-----END OF FUNCTIONS-------------


void setup(){
  size(800,500);
  ellipseMode(CENTER);
  rectMode(CENTER);
}


void draw(){
  background(255);
  
  //Iterates through all balloons
  for(int balloonNum = 0; balloonNum < level1.length; balloonNum++){
    updatePositions(level1[balloonNum]);
  }
  
  //Tower
  pushMatrix();
    rotateBuilding(level1[0]);
  popMatrix();
}
