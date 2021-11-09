public class Projectile {
  private PVector center, velocity;
  private float angle;
  private final float radius = 15;
  public Projectile(PVector centre, PVector velocity) {
    this.center = centre;
    this.velocity = velocity;
  }
  public void draw() {
    stroke(#7b9d32);
    strokeWeight(4);
    float width = cos(angle), height = sin(angle);
    PVector displacement = new PVector(width, height).mult(radius);
    PVector start = PVector.add(center, displacement), end = PVector.sub(center, displacement);
    line(start.x, start.y, end.x, end.y);
    angle += 5 * PI / 180;
    center = PVector.add(center, velocity);
  }
  public float dist(PVector point) {
    float width = cos(angle), height = sin(angle);
    PVector displacement = new PVector(width, height).mult(radius);
    PVector start = PVector.add(center, displacement), end = PVector.sub(center, displacement);
    return pointDistToLine(start, end, point);
  }
}
