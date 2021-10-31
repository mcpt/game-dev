//-----GLOBAL VARIABLES------

int currentLevel = 0;

//variables to control the square that tracks the balloons
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

/*
  Heath-related variables:
    int health: The player's total health.
                This number decreases if balloons pass the end of the path (offscreen), currentely 12 since there are 12 balloons.
    boolean[] offscreen: this array tracks if the balloon has been subtracted from health once it is off the screen.
    PImage heart: the heart icon to display with the healthbar.
*/
int health = 12;  //variable to track user's health
boolean[] offscreen = new boolean[level1.length]; //creates new boolean array with length of the # of balloons there are
PImage heart;

//-----END OF GLOBAL VARIABLES------


//-----FUNCTIONS--------------------

//Updates the position of balloons & check if the balloon is still on the screen
void updatePositions(float[] balloonProps, int bNum){
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
  
  /*
    Check if the balloon has moved off the screen.
    if statement checks if the balloon's coordinates are off the screen, and if it hasn't been subtracted from the health yet.
    If the value at index bNum is already true, then the balloon was offscreen last time void draw() ran, so the health doesn't need to go down.
    However, if there is a new balloon that just went offscreen (value at index bNum in offscreen is false), the health has to go down.
  */
  if(balloonProps[0]>800 && !offscreen[bNum]){
    health--;
    offscreen[bNum] = true;
  }
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

//method to draw a healthbar at the top right of the screen 
void drawHealthBar(){
  //draw healthbar outline
  stroke(0,0,0);
  fill(#830000);
  rect(715,25,120,20);
  
  //draw healthbar
  noStroke();
  rectMode(CORNER);
  fill(#FF3131);
  rect(655,15.5,health*10,20); //the healthbar that changes based on hp
  rectMode(CENTER);
  noFill();
  
  //write text
  stroke(0,0,0);
  textSize(14);
  fill(255,255,255);
  text("Health:   "+health,670,32);
  
  //put the heart.png image on screen
  image(heart,650,26);
  noFill();
}

//-----END OF FUNCTIONS-------------


void setup(){
  size(800,500);
  ellipseMode(CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
  heart = loadImage("heart.png");
}


void draw(){
  background(255);
  
  //Iterates through all balloons
  for(int balloonNum = 0; balloonNum < level1.length; balloonNum++){
    updatePositions(level1[balloonNum],balloonNum);
    drawHealthBar();
  }
  
  //Tower
  pushMatrix();
    rotateBuilding(level1[0]);
  popMatrix();
}
