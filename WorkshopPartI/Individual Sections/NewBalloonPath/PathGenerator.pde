class PathGenerator {
  private ArrayList<PVector> points;
  public PathGenerator() {
    points = new ArrayList<>();
  }
  public void draw() {
    for (int i = 0; i < points.size() - 1; i++) {
      PVector currentPoint = points.get(i);
      PVector nextPoint = points.get(i + 1);
      stroke(0);
      line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
    }
  }
  public void add(float x, float y) {
    points.add(new PVector(x, y)); 
  }
  public PVector getLocation(float travelDistance) {
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
}
