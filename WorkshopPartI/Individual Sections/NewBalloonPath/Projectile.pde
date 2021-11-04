class Projectile {
  private PVector position, velocity;
  public Projectile(PVector start, PVector velocity) {
    this.position = start;
    this.velocity = velocity;
  }
  public boolean outOfBounds() {
    return position.x < 0 || position.x > 800 || position.y < 0 || position.y > 500;
  }
  public void draw() {
    position.add(velocity);
    fill(255,0,0);
    ellipse(position.x, position.y, 5, 5);
  }
   
}

/*
// Code for projectile adding

if (targetFound && framesElapsed % cooldown == 0) {
    float speed = 25;
    float split = PI / 16;
    for (int i = -2; i <= 2; i++)
      projectiles.add(new Projectile(new PVector(rectX, rectY), new PVector(cos(angle + split * i) * speed, sin(angle + split * i) * speed)));
  }
*/
