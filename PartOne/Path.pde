/*
Encompasses: The Path for Balloons, Balloon Movement
*/

// ------- CODE FOR THE PATH 
ArrayList<PVector> points = new ArrayList<>(); // The points on the path, in order. 
final float PATH_RADIUS = 20;
void addPointToPath(float x, float y) {
    points.add(new PVector(x, y)); 
}

void initPath() {
  addPointToPath(0, 200);
  addPointToPath(50, 200);
  addPointToPath(200, 150);
  addPointToPath(350, 200);
  addPointToPath(500, 150);
  addPointToPath(650, 200);
  addPointToPath(650, 300);
  addPointToPath(500, 250);
  addPointToPath(350, 300);
  addPointToPath(200, 250);
  addPointToPath(50, 300);
  addPointToPath(50, 400);
  addPointToPath(200, 350);
  addPointToPath(350, 400);
  addPointToPath(500, 350);
  addPointToPath(650, 400);
  addPointToPath(800, 350);
}

void drawPath() {
  stroke(#4C6710);
  strokeWeight(PATH_RADIUS * 2 + 1);
  for (int i = 0; i < points.size() - 1; i++) {
    PVector currentPoint = points.get(i);
    PVector nextPoint = points.get(i + 1);
    line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
  }
  
  stroke(#7b9d32);
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
