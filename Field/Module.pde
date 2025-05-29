public class Module{
    private float angle;
    private float angularVelocity;
    private PVector velocity;
    private PVector pos;

    private float angularAccel;
    private PVector accel;

    public Module(float angle, PVector pos){
      this.angle = angle;
      angularVelocity = 0;
      this.pos = pos;
      velocity = new PVector(0, 0);
      
      angularAccel = 0;
      accel = new PVector(0, 0);
    }

    public void update(PVector accel, float angularAccel float dt){
      // NOTE: dt should be in seconds (eg. 0.02 secs)
      // Verlet Integration: https://en.wikipedia.org/wiki/Verlet_integration
      this.angularAccel = angularAccel;
      this.accel = accel;

      // updating positions
      pos.x += velocity.x * dt + 0.5 * accel.x * dt * dt;
      pos.y += velocity.y * dt + 0.5 * accel.y * dt * dt;
      angle = (angle + angularVelocity * dt + 0.5 * angularAccel * dt * dt) % 360;
      while (angle < 0) angle += 360;

      // updating velocities
      velocity.x += accel.x * dt;
      velocity.y += accel.y * dt;
      angularVelocity += angularAccel * dt;
    }
    
    public float getAngle() { // degrees
      return angle;
    }
    
    public float getAngularVelocity() { // degrees per second
      return angularVelocity;
    }
    
    public PVector getPosition() { // (x, y)
      return pos;
    }
    
    public PVector getVelocity() { // XY velocity
      return velocity;
    }

    public void setAngle(float angle) {
      this.angle = angle % 360;
      while (this.angle < 0) this.angle += 360;
    }
    
    public void setPosition(PVector pos) {
      this.pos = pos;
    }
    
    public void draw(){
       pushMatrix();
       translate(pos.x, pos.y); // move coordinate system to center of module
       rotate(radians(angle)); // rotate coordinate system by angle of module
       
       float s = 8;
       fill(255, 0, 0);
       stroke(0);
       strokeWeight(1);
       
       // draw square representing module
       beginShape();
       vertex(-s, s);
       vertex(s, s);
       vertex(s, -s);
       vertex(-s, -s);
       endShape(CLOSE);
       
       float t = 4;
       fill(0, 255, 0);
       stroke(0);
       strokeWeight(1);
       
       // draw triangle representing module direction
       beginShape();
       vertex(t, 0);
       vertex(-t/2, t/2);
       vertex(-t/2, -t/2);
       endShape(CLOSE);
       
       popMatrix();
    }
}
