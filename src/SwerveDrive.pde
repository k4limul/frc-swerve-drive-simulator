public class SwerveDrive {
    // Framerate -- constant
    private static final float DT = 1.0 / 60.0;
    private static final float maxTranslationalVelocity = 500.0;

    // Swerve attributes
    private PVector robotPosition;
    private float robotAngle;
    private PVector robotVelocity;
    private float robotAngularVelocity;
    private Module[] modules;

    // States for more realistic motion
    private PVector targetVelocity;
    private float targetAngularVelocity;

    private WheelTread wheelTread;
    private float mass;

    public SwerveDrive(PVector startPos, float startAngle, Module[] modules, float mass, WheelTread wheelTread) {
        robotPosition = startPos;
        robotAngle = startAngle;
        robotVelocity = new PVector(0, 0);
        robotAngularVelocity = 0;
        
        targetVelocity = new PVector(0, 0);
        targetAngularVelocity = 0;

        this.modules = modules;
        this.mass = mass;
        this.wheelTread = wheelTread;
    }

    // Called every frame in main class to update the robot's states
    public void update() {
        applyPhysics();
        updateModuleStates();

        for (Module m : modules) {
            m.update(DT);
        }
        updateRobotPose();
    }

    // Called with keyboard inputs
    public void drive(float vx, float vy, float omega) {
        PVector inputVel = new PVector(vx, vy);
        if (inputVel.mag() > maxTranslationalVelocity) {
            inputVel.normalize();
            inputVel.mult(maxTranslationalVelocity);
        }

        targetVelocity.set(inputVel.x, inputVel.y);
        targetAngularVelocity = omega;
    }

    private void applyPhysics() {
        float tractionFactor = wheelTread.getTractionCoefficient();
        float massFactor = 100.0 / mass;
        float physicsFactor = tractionFactor * massFactor * DT;

        // Rate limit both velocities based on physics factor
        PVector velocityDiff = PVector.sub(targetVelocity, robotVelocity);
        velocityDiff.mult(physicsFactor);
        robotVelocity.add(velocityDiff);

        float angularDiff = targetAngularVelocity - robotAngularVelocity;
        robotAngularVelocity += angularDiff * physicsFactor;
    }

    // Set module targets based off robot targets
    private void updateModuleStates() {
        for (Module m : modules) {
            PVector moduleVel = calculateModuleVelocity(robotVelocity.x, robotVelocity.y, targetAngularVelocity, m.getPosition());
            m.setTargetState(moduleVel);
        }
    }

    /* 
     * This takes the target translational and rotational velocities from the user (ROBOT),
     * then outputs a target velocity vector (MODULE, remember: angle = atan2(vector) and speed = mag(vector))
    */
    private PVector calculateModuleVelocity(float vx_field, float vy_field, float omega, PVector pos) {
        // Cross product of omega and R (radius, or distance from center)
        // This gives us the perpendicular, velocity (v = wR) at the module's position
        float omegaRad = radians(omega);
        float rotationalVx = -omegaRad * pos.y;
        float rotationalVy = omegaRad * pos.x;
        
        // Recall that wheel velocity must = Translation + Rotation effect
        return new PVector(vx_field + rotationalVx, vy_field + rotationalVy);
    }

    private void updateRobotPose() {
        PVector totalVel = new PVector(0, 0);
        float totalOmega = 0;

        for (Module m : modules) {
            PVector mVel = m.getVelocityContribution();
            totalVel.add(mVel);

            PVector pos = m.getPosition();
            
            float rotationContribution = (mVel.x * pos.y - mVel.y * pos.x) / pos.magSq(); // stolen from online
            totalOmega += rotationContribution;
        }

        // Average the module velocities
        robotVelocity = PVector.div(totalVel, 4);
        robotAngularVelocity = degrees(totalOmega / 4);
        
        PVector newPos = PVector.add(robotPosition, PVector.mult(robotVelocity, DT));
        
        float robotRadius = 20;
        newPos.x = constrain(newPos.x, robotRadius, width - robotRadius);
        newPos.y = constrain(newPos.y, robotRadius, height - robotRadius);
    
        robotPosition = newPos;
        robotAngle += robotAngularVelocity * DT;
        
        // Normalize robot angle within bounds
        robotAngle = robotAngle % 360;
        if (robotAngle < 0) robotAngle += 360;
    }

    // GETTERS
    public PVector getRobotPosition() { return robotPosition.copy(); }
    public float getRobotAngle() { return robotAngle; }
    public PVector getRobotVelocity() { return robotVelocity.copy(); }
    public float getRobotAngularVelocity() { return robotAngularVelocity; }

    // Draw robot and modules on canvas!
    public void draw(boolean isBlue) {
        float s = 20;
        float t = 10;

        pushMatrix();
        translate(robotPosition.x, robotPosition.y); // move coordinate system to center of robot
        rotate(radians(robotAngle)); // rotate coordinate system by angle of robot
        noFill();
        if (isBlue) {
            stroke(0, 0, 255);
        } else {
            stroke(255, 0, 0);
        }
        strokeWeight(1);
        
        // draw square representing robot center
        beginShape();
        vertex(-s, s);
        vertex(s, s);
        vertex(s, -s);
        vertex(-s, -s);
        endShape(CLOSE);
        
        noFill();
        stroke(0, 255, 0);
        strokeWeight(1);
        
        // draw triangle representing robot direction
        beginShape();
        vertex(t, 0);
        vertex(-t/2, t/2);
        vertex(-t/2, -t/2);
        endShape(CLOSE);

        popMatrix();

        for (Module m : modules) {
            m.draw(robotPosition, robotAngle, s, t, isBlue);
        }
    }
}
