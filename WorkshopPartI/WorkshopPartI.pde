ArrayList<PVector> enemyLocation;
ArrayList<Float> enemySpeed;
final PVector enemyStartLocation = new PVector(0, 0); // Add values to this 
int framesElapsed;

void setup() {
  enemyLocation = new ArrayList<>();
  enemySpeed = new ArrayList<>();
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

void draw() {
  spawnWaves();
  for (int i = 0; i < enemyLocation.size(); i++) {
    PVector currentLocation = enemyLocation.get(i);
    float speed = enemySpeed.get(i);
    PVector nextLocation = nextLocation(currentLocation, speed);
    enemyLocation.set(i, nextLocation);
    
    drawEnemy(nextLocation);
  }
}
