public class Projectile {
  private PVector center, velocity;
  private float angle;
  private final float radius = 11;
  private float damage;
  private float maxDistTravelled;
  private float currDistTravelled = 0;
  private String dmgType;
  
  private int pierce;
  private ArrayList<float[]> balloonsHit; // Checks via reference... (change this to be more suitable for the workshop? Maybe have each balloon have a specific ID instead?)
  public Projectile(PVector centre, PVector velocity, float damage, int pierce, float maxDistTravelled, String dmgType) {
    balloonsHit = new ArrayList<float[]>();
    this.center = centre;
    this.velocity = velocity;
    this.angle = atan2(velocity.y, velocity.x);
    this.damage = damage;
    this.pierce = pierce;
    this.maxDistTravelled = maxDistTravelled;
    this.dmgType = dmgType;
  }
  public void hitBalloon(float[] balloon) {
    if (pierce == 0 || balloonsHit.contains(balloon)) return;
    pierce--;
    balloon[hp] -= damage;
    if(dmgType.equals("slow") && balloon[slowed]==0){
      balloon[speed] -=1; 
      balloon[slowed]=1;
    }
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
    currDistTravelled += velocity.mag();
  }
  public float dist(PVector point) {
    float width = cos(angle), height = sin(angle);
    PVector displacement = new PVector(width, height).mult(radius);
    PVector start = PVector.add(center, displacement), end = PVector.sub(center, displacement);
    return pointDistToLine(start, end, point);
  }
  public boolean dead() {
    return offScreen() || pierce == 0 || currDistTravelled > maxDistTravelled;
  }
  public boolean offScreen() { 
    return center.x < 0 || center.x > 800 || center.y < 0 || center.y > 500;
  }
}

final int cooldownRemaining = 0, maxCooldown = 1, projectileType = 2;

void handleProjectiles() {
  for(int i = 0; i < towers.size(); i++) {
    PVector location = towers.get(i);
    int[] data = towerData.get(i);
    data[cooldownRemaining]--;
    if (data[cooldownRemaining] <= 0) {
      data[cooldownRemaining] = data[maxCooldown];
      PVector balloon = furthestBalloon();
      if(balloon == null) return;
      
      PVector toMouse = new PVector(balloon.x - location.x, balloon.y - location.y); 
      
      if (data[projectileType] == 0) {
        final int speed = 24, damage = 6, pierce = 1, maxTravelDist = 500;
        PVector unitVector = PVector.div(toMouse, toMouse.mag());
        
        PVector velocity = PVector.mult(unitVector, speed);
        Projectile projectile = new Projectile(location, velocity, damage, pierce, maxTravelDist,"default");
        projectiles.add(projectile);
        
        // Default type
      } else if (data[projectileType] == 1) {
        // Spread in 8
        for (int j = 0; j < 8; j++) {
          final int speed = 12, damage = 4, pierce = 2, maxTravelDist = 150;
          float angle = (PI * 2) * j / 8;
          PVector unitVector = PVector.div(toMouse, toMouse.mag());
          
          PVector velocity = PVector.mult(unitVector, speed).rotate(angle);
          Projectile projectile = new Projectile(location, velocity, damage, pierce, maxTravelDist,"default");
          projectiles.add(projectile);
        }
      } else if (data[projectileType] == 2) {
        //glue gunner - slows balloons
        final int speed = 12, damage = 1, pierce = 7, maxTravelDist = 100; //slow-ish speed, low damage, high pierce, low range
        PVector unitVector = PVector.div(toMouse, toMouse.mag());
        
        PVector velocity = PVector.mult(unitVector, speed);
        Projectile projectile = new Projectile(location, velocity, damage, pierce, maxTravelDist,"slow");
        projectiles.add(projectile);
      }
    }
  }
  
  for(int i = 0; i < projectiles.size(); i++) {
    Projectile p = projectiles.get(i);
    p.draw();
    if (p.dead()) {
      projectiles.remove(i);
      i--;
    }
  }
}
