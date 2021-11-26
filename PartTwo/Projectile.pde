ArrayList<PVector> center = new ArrayList<PVector>(), velocity = new ArrayList<PVector>();
ArrayList<float[]> projectileData = new ArrayList<float[]>();
ArrayList<ArrayList<Integer>> balloonsHit = new ArrayList<ArrayList<Integer>>();
final int damage = 0, pierce = 1, angle = 2, currDistTravelled = 3, maxDistTravelled = 4, thickness = 5, dmgType = 6;
final int projectileRadius = 11;

void createProjectile(PVector centre, PVector vel, float damage, int pierce, float maxDistTravelled, float thickness, int dmgType) {
  balloonsHit.add(new ArrayList<Integer>());
  center.add(centre);
  velocity.add(vel);
  float angle = atan2(vel.y, vel.x);
  projectileData.add(new float[]{damage, pierce, angle, 0, maxDistTravelled, thickness, dmgType});
}
float distToProjectile(int projectileID, PVector point) {
  float[] data = projectileData.get(projectileID);
  float width = cos(data[angle]), height = sin(data[angle]);
  PVector displacement = new PVector(width, height).mult(projectileRadius);
  if (data[dmgType] == laser) displacement.mult(1000);
  PVector start = PVector.add(center.get(projectileID), displacement), end = PVector.sub(center.get(projectileID), displacement);
  if (data[dmgType] == laser) end = center.get(projectileID);
  return pointDistToLine(start, end, point);
}
public boolean dead(int projectileID) {
  float[] data = projectileData.get(projectileID);
  return offScreen(projectileID) || data[pierce] == 0 || data[currDistTravelled] > data[maxDistTravelled];
}
public boolean offScreen(int projectileID) { 
  return center.get(projectileID).x < 0 || center.get(projectileID).x > 800 || center.get(projectileID).y < 0 || center.get(projectileID).y > 500;
}

void drawProjectile(int projectileID) {
  float[] data = projectileData.get(projectileID);
  stroke(255);
  strokeWeight(data[thickness]);
  float width = cos(data[angle]), height = sin(data[angle]);
  PVector displacement = new PVector(width, height).mult(projectileRadius);
  if (data[dmgType] == laser) displacement.mult(1000);
  PVector start = PVector.add(center.get(projectileID), displacement), end = PVector.sub(center.get(projectileID), displacement);
  if (data[dmgType] == laser) end = center.get(projectileID);
  line(start.x, start.y, end.x, end.y);

  handleCollision(projectileID);
  if (data[dmgType] != laser)
    center.set(projectileID, PVector.add(center.get(projectileID), velocity.get(projectileID)));
  if (data[dmgType] != laser)
    data[currDistTravelled] += velocity.get(projectileID).mag();
  else data[currDistTravelled]++;
}

void hitBalloon(int projectileID, float[] balloonData) {
  float[] data = projectileData.get(projectileID);
  if (data[pierce] == 0 || balloonsHit.get(projectileID).contains((int) balloonData[ID])) return;
  data[pierce]--;
  balloonData[hp] -= data[damage];
  if(data[dmgType] == slow && balloonData[slowed] == 0){
    balloonData[speed] *= 0.7; 
    balloonData[slowed] = 1;
  }
  balloonsHit.get(projectileID).add((int) balloonData[ID]);
}

void handleCollision(int projectileID) {
  float[] data = projectileData.get(projectileID);
  for(float[] balloon: balloons) {
    if (balloon[delay] != 0) continue; // If the balloon hasn't entered yet, don't count it
    PVector position = getLocation(balloon[distanceTravelled]);
    if(distToProjectile(projectileID, position) <= balloonRadius / 2 + data[thickness] / 2) {
      hitBalloon(projectileID, balloon);
    }
  }
}
//-------------------------------- PROJECTILE CREATION (Participants will NOT be required to code the stuff above this line) -----------------------------------
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
        createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, def);
        // Default type
      } else if (data[projectileType] == 1) {
        // Spread in 8
        for (int j = 0; j < 8; j++) {
          final int speed = 12, damage = 3, pierce = 2, maxTravelDist = 150, thickness = 4;
          float angle = (PI * 2) * j / 8;
          PVector unitVector = PVector.div(toMouse, toMouse.mag());
          
          PVector velocity = PVector.mult(unitVector, speed).rotate(angle);
          createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, eight);
        }
      } else if (data[projectileType] == 2) {
        //glue gunner - slows balloons
        final int speed = 15, damage = 1, pierce = 7, maxTravelDist = 220, thickness = 4; //slow-ish speed, low damage, high pierce, low range
        PVector unitVector = PVector.div(toMouse, toMouse.mag());
        
        PVector velocity = PVector.mult(unitVector, speed);
        createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, slow);
      } else if (data[projectileType] == 3) {
        final int speed = 1, pierce = 50, maxTravelDist = data[maxCooldown], thickness = 32; // speed & travel dist are custom, maxTravelDist basically acts like a counter 
        final float damage = 0.10;
        PVector unitVector = PVector.div(toMouse, toMouse.mag());
        
        PVector velocity = PVector.mult(unitVector, speed);
        createProjectile(location, velocity, damage, pierce, maxTravelDist, thickness, laser);
      }
    }
  }
  for(int i = 0; i < projectileData.size(); i++) {
    drawProjectile(i);
    if (dead(i)) {
      projectileData.remove(i);
      center.remove(i);
      velocity.remove(i);
      balloonsHit.remove(i);
      i--;
    }
  }
}
