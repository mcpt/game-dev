/*
Encompasses: The Path for Balloons, Balloon Movement
*/

// ------- CODE FOR THE PATH 
ArrayList<PVector> points = new ArrayList<>(); // The points on the path, in order. 
final float PATH_RADIUS = 15;
void addPointToPath(float x, float y) {
    points.add(new PVector(x, y)); 
}

void initPath() {
  addPointToPath(0, 200);
  addPointToPath(300, 100);
  addPointToPath(200, 100);
  addPointToPath(250, 400);
  addPointToPath(300, 350);
  addPointToPath(350, 450);
  addPointToPath(400, 50);
  addPointToPath(700, 400);
}

void drawPath() {
  stroke(0);
  strokeWeight(PATH_RADIUS * 2 + 1);
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
  }
  
  stroke(#8B5C35);
  strokeWeight(PATH_RADIUS * 2);
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
  }
}

// GIVEN TO PARTICIPANTS BY DEFAULT
PVector getLocation(float travelDistance) 
{
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    float distance = dist(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
    if (distance <= EPSILON || travelDistance >= distance) {
      travelDistance -= distance;
    } else {
      // In between two points
      float travelProgress = travelDistance / distance;
      float xDist = nextPoint.x - currentPoint.x;
      float yDist = nextPoint.y - currentPoint.y;
      float x = currentPoint.x + xDist * travelProgress;
      float y = currentPoint.y + yDist * travelProgress;
      return new PVector(x, y);
    }
  }
  // At end of path
  return points.get(points.size() - 1);
}
