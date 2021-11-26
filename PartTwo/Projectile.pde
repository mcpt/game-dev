public class Projectile {
  private PVector center, velocity;
  private float angle;
  private final float radius = 11;
  private float thickness;
  private float damage;
  private float maxDistTravelled;
  private float currDistTravelled = 0;
  private String dmgType;
  
  private int pierce;
  private ArrayList<float[]> balloonsHit; // Checks via reference... (change this to be more suitable for the workshop? Maybe have each balloon have a specific ID instead?)
  public Projectile(PVector centre, PVector velocity, float damage, int pierce, float maxDistTravelled, float thickness, String dmgType) {
    balloonsHit = new ArrayList<float[]>();
    this.center = centre;
    this.velocity = velocity;
    this.angle = atan2(velocity.y, velocity.x);
    this.damage = damage;
    this.pierce = pierce;
    this.maxDistTravelled = maxDistTravelled;
    this.dmgType = dmgType;
    this.thickness = thickness;
  }
  public void hitBalloon(float[] balloon) {
    if (pierce == 0 || balloonsHit.contains(balloon)) return;
    pierce--;
    balloon[hp] -= damage;
    if(dmgType.equals("slow") && balloon[slowed]==0){
      balloon[speed] *= 0.7; 
      balloon[slowed]=1;
    }
    balloonsHit.add(balloon);
  }
  public void collisionWithBalloons() {
    for(float[] balloon: balloons) {
      if (balloon[delay] != 0) continue; // If the balloon hasn't entered yet, don't count it
      PVector position = getLocation(balloon[distanceTravelled]);
      if(this.dist(position) <= balloonRadius / 2 + thickness / 2) {
        hitBalloon(balloon);
      }
    }
  }
  public void draw() {
    stroke(255);
    strokeWeight(thickness);
    float width = cos(angle), height = sin(angle);
    PVector displacement = new PVector(width, height).mult(radius);
    if (dmgType.equals("laser")) displacement.mult(1000);
    PVector start = PVector.add(center, displacement), end = PVector.sub(center, displacement);
    if (dmgType.equals("laser")) end = center;
    line(start.x, start.y, end.x, end.y);

    collisionWithBalloons();
    // Updating angle and center
    // angle += 5 * PI / 180;
    angle %= 360;
    if (!dmgType.equals("laser"))
      center = PVector.add(center, velocity);
    if (!dmgType.equals("laser"))
      currDistTravelled += velocity.mag();
    else currDistTravelled++;
  }
  public float dist(PVector point) {
    float width = cos(angle), height = sin(angle);
    PVector displacement = new PVector(width, height).mult(radius);
    if (dmgType.equals("laser")) displacement.mult(1000);
    PVector start = PVector.add(center, displacement), end = PVector.sub(center, displacement);
    if (dmgType.equals("laser")) end = center;
    return pointDistToLine(start, end, point);
  }
  public boolean dead() {
    return offScreen() || pierce == 0 || currDistTravelled > maxDistTravelled;
  }
  public boolean offScreen() { 
    return center.x < 0 || center.x > 800 || center.y < 0 || center.y > 500;
  }
}

//-------------------------------- PROJECTILE CREATION (Participants will NOT be required to code the stuff above this line) -----------------------------------
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();

PVector track(PVector towerLocation, int vision) {
  float maxDist = 0;
  PVector location = null;
  for(float[] balloon: balloons) {
    PVector balloonLocation = getLocation(balloon[distanceTravelled]);
    // Checks if the tower can see the balloon
    if (dist(balloonLocation.x, balloonLocation.y, towerLocation.x, towerLocation.y) <= vision) {
      // If the balloon has travelled further than the previously stored one, it is now the new fastest
      if(balloon[distanceTravelled] > maxDist) {
        location = balloonLocation;
        maxDist = balloon[distanceTravelled];
      }
    }
  }
  return location;
}

void handleProjectiles() {
  for(int i = 0; i < towers.size(); i++) {
    PVector location = towers.get(i);
    int[] data = towerData.get(i);
    data[cooldownRemaining]--;
    PVector balloon = track(location, data[towerVision]);
    if (data[projectileType] == laser) balloon = new PVector(mouseX, mouseY);

    // Cooldown is 0 and there is a balloon that the tower tracks shoots a projectile 
    if (data[cooldownRemaining] <= 0 && balloon != null) {
      data[cooldownRemaining] = data[maxCooldown]; // Resets the cooldown 
      
      PVector toMouse = new PVector(balloon.x - location.x, balloon.y - location.y); 
      
      if (data[projectileType] == 0) {
        final int speed = 24, damage = 4, pierce = 1, maxTravelDist = 500, thickness = 4;
        PVector unitVector = PVector.div(toMouse, toMouse.mag());
        
        PVector velocity = PVector.mult(unitVector, speed);
        Projectile projectile = new Projectile(location, velocity, damage, pierce, maxTravelDist, thickness, "default");
        projectiles.add(projectile);
        
        // Default type
      } else if (data[projectileType] == 1) {
        // Spread in 8
        for (int j = 0; j < 8; j++) {
          final int speed = 12, damage = 3, pierce = 2, maxTravelDist = 150, thickness = 4;
          float angle = (PI * 2) * j / 8;
          PVector unitVector = PVector.div(toMouse, toMouse.mag());
          
          PVector velocity = PVector.mult(unitVector, speed).rotate(angle);
          Projectile projectile = new Projectile(location, velocity, damage, pierce, maxTravelDist, thickness, "default");
          projectiles.add(projectile);
        }
      } else if (data[projectileType] == 2) {
        //glue gunner - slows balloons
        final int speed = 15, damage = 1, pierce = 7, maxTravelDist = 220, thickness = 4; //slow-ish speed, low damage, high pierce, low range
        PVector unitVector = PVector.div(toMouse, toMouse.mag());
        
        PVector velocity = PVector.mult(unitVector, speed);
        Projectile projectile = new Projectile(location, velocity, damage, pierce, maxTravelDist, thickness, "slow");
        projectiles.add(projectile);
      } else if (data[projectileType] == 3) {
        final int speed = 1000, pierce = 50, maxTravelDist = data[maxCooldown], thickness = 32; // speed & travel dist are custom, maxTravelDist basically acts like a counter 
        final float damage = 0.16;
        PVector unitVector = PVector.div(toMouse, toMouse.mag());
        
        PVector velocity = PVector.mult(unitVector, speed);
        Projectile projectile = new Projectile(location, velocity, damage, pierce, maxTravelDist, thickness, "laser");
        projectiles.add(projectile);
      }
    }
  }
  ArrayList<Projectile> newListWithoutDeadProjectiles = new ArrayList<Projectile>();
  for(int i = 0; i < projectiles.size(); i++) {
    Projectile p = projectiles.get(i);
    p.draw();
    if (!p.dead()) {
      newListWithoutDeadProjectiles.add(p);
    }
  }
  projectiles = newListWithoutDeadProjectiles;
}
