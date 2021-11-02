// ASSUMPTIONS: Path is full of geometric stadiums with radius PATH_RADIUS
final float PATH_RADIUS = 15;
float pointDistToLine(PVector start, PVector end, PVector point) {
  // Code from https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment 
  // Return minimum distance between line segment vw and point p
  float l2 = (start.x - end.x) * (start.x - end.x) + (start.y - end.y) * (start.y - end.y);  // i.e. |w-v|^2 -  avoid a sqrt
  if (l2 == 0.0) return dist(end.x, end.y, point.x, point.y);   // v == w case
  // Consider the line extending the segment, parameterized as v + t (w - v).
  // We find projection of point p onto the line. 
  // It falls where t = [(p-v) . (w-v)] / |w-v|^2
  // We clamp t from [0,1] to handle points outside the segment vw.
  float t = max(0, min(1, PVector.sub(point,start).dot(PVector.sub(end,start)) / l2));
  PVector projection = PVector.add(start, PVector.mult(PVector.sub(end,start),t));  // Projection falls on the segment
  return dist(point.x, point.y, projection.x, projection.y);
}
class PathGenerator {
  private ArrayList<PVector> points;
  public PathGenerator() {
    points = new ArrayList<>();
  }
  public float shortestDist(PVector point) {
    float answer = Float.MAX_VALUE;
    for (int i = 0; i < points.size() - 1; i++) {
      PVector start = points.get(i);
      PVector end = points.get(i + 1);
      float distance = pointDistToLine(start, end, point);
      answer = min(answer, distance);
    }
    return answer;
  }
  public void draw() {
    stroke(#6786FA);
    strokeWeight(PATH_RADIUS * 2);
    for (int i = 0; i < points.size() - 1; i++) {
      PVector currentPoint = points.get(i);
      PVector nextPoint = points.get(i + 1);
      
      line(currentPoint.x, currentPoint.y, nextPoint.x, nextPoint.y);
    }
    strokeWeight(1);
    stroke(0);
  }
  public void add(float x, float y) {
    points.add(new PVector(x, y)); 
  }
  public PVector getLocation(float travelDistance) // GIVEN TO PARTICIPANTS BY DEFAULT
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
}
