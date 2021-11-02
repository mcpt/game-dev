class Projectile {
  private PVector position, velocity;
  public Projectile(PVector start, PVector velocity) {
    this.position = start;
    this.velocity = velocity;
  }
  public void draw() {
    position.add(velocity);
    ellipse(position.x, position.y, 20, 20);
  }
   
}
