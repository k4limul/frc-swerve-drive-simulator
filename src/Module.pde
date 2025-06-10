public class Module {
  // Fixed position -- module's position relative to robot center
  private PVector posFromCenter;

  // Module states -- what we control
  private float angle;
  private float speed;
  private float angularVelocity;

  // Current states -- used for updating states every frame 
  private float currentAngle;
  private float currentSpeed;

  // Limits -- improves physics simulation
  private float maxDriveSpeed;
  private float maxTurnSpeed;

  private boolean shouldReverse;

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
    float calculatedAngle = degrees(atan2(targetVelocity.y, targetVelocity.x)); // point in the direction of the targetVelocity
    float calculatedSpeed = targetVelocity.mag(); // speed is a scalar quantity

    this.angle = optimizeAngle(calculatedAngle);
    this.speed = shouldReverse ? -calculatedSpeed : calculatedSpeed;
  }

  // Called every frame to update module state -- rate limit lin/ang velocities
  public void update(float dt) {
    // Velocity limit
    currentSpeed = constrain(speed, -maxDriveSpeed, maxDriveSpeed);
    
    // Angular Velocity limit
    float angleDiff = angle - currentAngle; // how much to add to currentAngle at the end of update step

    if (angleDiff > 180) angleDiff -= 360; // difference has to be within bounds
    if (angleDiff < -180) angleDiff += 360; // bounds: (-180, 180)

    // Limiting step
    float maxAngleDiff = maxTurnSpeed * dt;
    angleDiff = constrain(angleDiff, -maxAngleDiff, maxAngleDiff);

    // Normalize new, calculated angle to (0, 360)
    currentAngle = (((currentAngle + angleDiff) % 360) + 360) % 360;
  }

  public float optimizeAngle(float targetAngle) {
    float current = ((currentAngle % 360) + 360) % 360;
    float target = ((targetAngle % 360) + 360) % 360;

    float diff = target - current;

    // Keep mag of diff less than 180 deg
    while (diff > 180) diff -= 360;
    while (diff < -180) diff += 360;
    
    // Find the other way to get to the target angle
    float reverseDiff = diff > 0 ? diff - 180 : diff + 180;
    
    // Compare both paths and choose the one that requires least turning
    if (Math.abs(reverseDiff) < Math.abs(diff)) {
      shouldReverse = true;
      return current + reverseDiff;
    } else {
      shouldReverse = false;
      return current + diff;
    }
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
  public float getTargetAngle() { return angle; }
  public float getTargetSpeed() { return speed; }
  public float getAngularVelocity() { return angularVelocity; }
  
  // Visualize this module on the processing canvas
  public void draw(PVector robotCenter, float robotAngle, float s, float t, boolean isBlue) {
      pushMatrix();
      translate(robotCenter.x, robotCenter.y); // robot-relative coordinate system
      rotate(radians(robotAngle)); 
      translate(posFromCenter.x, posFromCenter.y); // module-relative coordinate system
      rotate(radians(currentAngle));

      noFill();
      if (isBlue) {
        stroke(0, 0, 255);
      } else {
          stroke(255, 0, 0);
      }
      strokeWeight(2);
      
      // draw square representing module
      beginShape();
      vertex(-s/2, s/2);
      vertex(s/2, s/2);
      vertex(s/2, -s/2);
      vertex(-s/2, -s/2);
      endShape(CLOSE);
      
      noFill();
      stroke(0, 255, 0);
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
