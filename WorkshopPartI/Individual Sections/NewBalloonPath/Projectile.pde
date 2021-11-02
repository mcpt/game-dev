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
    ellipse(position.x, position.y, 20, 20);
  }
   
}
