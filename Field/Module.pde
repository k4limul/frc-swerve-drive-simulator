public class Module {

  // fixed -- module's position relative to robot center
  private PVector posFromCenter;

  // module states -- what we control
  private float targetAngle;
  private float targetSpeed;
  private float targetAngularVelocity;

  // current states -- used for updating states every frame 
  private float currentAngle;
  private float currentSpeed;

  // limits -- improves physics simulation
  private float maxDriveSpeed;
  private float maxTurnSpeed;

  public Module(PVector posFromCenter, float maxDriveSpeed, float maxTurnSpeed){
    this.posFromCenter = posFromCenter;
    this.maxDriveSpeed = maxDriveSpeed;
    this.maxTurnSpeed = maxTurnSpeed;

    this.angle = 0;
    this.speed = 0;
    this.angularVelocity = 0;
    this.currentAngle = 0;
    this.currentSpeed = 0;
  }

  // called by the user when they want to change the target states
  public void setTargetState(PVector targetVelocity) {
    float calculatedAngle = degrees(atan2(targetVelocity.y, targetVelocity.x)); // point in the direction of the desiredVelocity
    float calculatedSpeed = targetVelocity.mag(); // speed is a scalar quantity

    this.targetAngle = calculatedAngle;
    this.targetSpeed = calculatedSpeed;
  }

  // called every frame to update module state
  public void update(float dt) {
    float angleDiff = angle - currentAngle;
    if (angleDiff > 180) angleDiff -= 360;
    if (angleDiff < -180) angleDiff += 360;

    float maxAngleDiff = maxTurnSpeed * dt;
    angleDiff = constrain(angleDiff, -maxAngleDiff, maxAngleDiff);

    currentAngle = (currentAngle + angleDiff) % 360;
    while (currentAngle < 0) currentAngle += 360;

    currentSpeed = speed;
    angularVelocity = angleDiff / dt;
  }

  // calculate how much the robot moves because of the module
  public PVector getVelocityContribution() {
    float angleRad = radians(currentAngle);
    return new PVector(currentSpeed * cos(angleRad), currentSpeed * sin(angleRad));
  }
  
  // GETTERS
  public PVector getPosition() { return posFromCenter; }
  public float getCurrentAngle() { return currentAngle; }
  public float getCurrentSpeed() { return currentSpeed; }
  public float getTargetAngle() { return targetAngle; }
  public float getTargetSpeed() { return targetSpeed; }
  public float getAngularVelocity() { return angularVelocity; }
  
  public void draw(PVector robotCenter, float robotAngle){
      pushMatrix();
      translate(robotCenter.x, robotCenter.y); // move coordinate system to center of module
      rotate(radians(robotAngle)); // rotate coordinate system by angle of module
      translate(posFromCenter.x, posFromCenter.y);
      
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
