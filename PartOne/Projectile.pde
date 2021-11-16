public class Projectile {
  private PVector center, velocity;
  private float angle;
  private final float radius = 11;
  private float dps;
  private int pierce;
  private ArrayList<float[]> balloonsHit; // Checks via reference... (change this to be more suitable for the workshop? Maybe have each balloon have a specific ID instead?)
  public Projectile(PVector centre, PVector velocity, float dps, int pierce) {
    balloonsHit = new ArrayList<float[]>();
    this.center = centre;
    this.velocity = velocity;
    this.angle = atan2(velocity.y, velocity.x);
    this.dps = dps;
    this.pierce = pierce;
  }
  public void hitBalloon(float[] balloon) {
    if (pierce == 0 || balloonsHit.contains(balloon)) return;
    pierce--;
    balloon[hp] -= dps;
    balloonsHit.add(balloon);
  }
  public void collisionWithBalloons() {
    for(float[] balloon: balloons) {
      PVector position = getLocation(balloon[distanceTravelled]);
      if(this.dist(position) <= balloonRadius / 2) {
        hitBalloon(balloon);
      }
    }
  }
  public void draw() {
    stroke(255);
    strokeWeight(4);
    float width = cos(angle), height = sin(angle);
    PVector displacement = new PVector(width, height).mult(radius);
    PVector start = PVector.add(center, displacement), end = PVector.sub(center, displacement);
    line(start.x, start.y, end.x, end.y);

    collisionWithBalloons();
    // Updating angle and center
    // angle += 5 * PI / 180;
    angle %= 360;
    center = PVector.add(center, velocity);
  }
  public float dist(PVector point) {
    float width = cos(angle), height = sin(angle);
    PVector displacement = new PVector(width, height).mult(radius);
    PVector start = PVector.add(center, displacement), end = PVector.sub(center, displacement);
    return pointDistToLine(start, end, point);
  }
  public boolean dead() {
    return offScreen() || pierce == 0;
  }
  public boolean offScreen() { 
    return center.x < 0 || center.x > 800 || center.y < 0 || center.y > 500;
  }
}
