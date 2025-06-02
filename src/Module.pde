public class Module {
  // Fixed position -- module's position relative to robot center
  private PVector posFromCenter;

  // Module states -- what we control
  private float targetAngle;
  private float targetSpeed;
  private float targetAngularVelocity;

  // Current states -- used for updating states every frame 
  private float currentAngle;
  private float currentSpeed;

  // Limits -- improves physics simulation
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

  // Called by the user when they want to change the target states
  public void setTargetState(PVector targetVelocity) {
    float calculatedAngle = degrees(atan2(targetVelocity.y, targetVelocity.x)); // point in the direction of the desiredVelocity
    float calculatedSpeed = targetVelocity.mag(); // speed is a scalar quantity

    this.targetAngle = calculatedAngle;
    this.targetSpeed = calculatedSpeed;
  }

  // Called every frame to update module state -- rate limit lin/ang velocities
  public void update(float dt) {
    // Velocity limit
    currentSpeed = constrain(targetSpeed, -maxDriveSpeed, maxDriveSpeed);
    
    // Angular Velocity limit
    float angleDiff = angle - currentAngle; // how much to add to currentAngle at the end of update step

    if (angleDiff > 180) angleDiff -= 360; // difference has to be within bounds
    if (angleDiff < -180) angleDiff += 360;

    // Limiting step
    float maxAngleDiff = maxTurnSpeed * dt;
    angleDiff = constrain(angleDiff, -maxAngleDiff, maxAngleDiff);

    // Normalize new, calculated angle to be within expected range (-180, 180)
    currentAngle = (currentAngle + angleDiff) % 360;
    while (currentAngle < 0) currentAngle += 360;
  }

  // Calculate how much the robot moves because of the module
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
  
  // Visualize this module on the processing canvas
  public void draw(PVector robotCenter, float robotAngle, float s, float t) {
      pushMatrix();
      translate(robotCenter.x, robotCenter.y); // move coordinate system to center of module
      rotate(radians(robotAngle)); // rotate coordinate system by angle of module
      translate(posFromCenter.x, posFromCenter.y);

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