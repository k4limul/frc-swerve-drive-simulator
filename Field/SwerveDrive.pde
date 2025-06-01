public class SwerveDrive {
    // Framerate -- constant
    private static final float DT = 1.0 / 60.0;

    // Swerve attributes
    private PVector robotPosition;
    private float robotAngle;
    private PVector robotVelocity;
    private float robotAngularVelocity;
    private Module[] modules;

    // States for more realistic motion
    private PVector robotAcceleration;
    private float robotAngularAcceleration;

    private WheelTread wheelTread;
    private float mass;

    public SwerveDrive(PVector startPos, float startAngle, Module[] modules, float mass, WheelTread wheelTread) {
        robotPosition = startPos;
        robotAngle = startAngle;
        robotVelocity = new PVector(0, 0);
        robotAngularVelocity = 0;

        robotAcceleration = new PVector(0, 0);
        robotAngularAcceleration = 0;

        this.modules = modules;
        this.mass = mass;
        this.wheelTread = wheelTread;
    }

    // Called every frame in main class to update the robot's states
    public void update() {
        for (Module m : modules) {
            m.update(DT);
        }
        updateRobotPose();
    }

    // Called with keyboard inputs
    public void drive(float vx, float vy, float omega) {
        for (Module m : modules) {
            PVector moduleVel = calculateModuleVelocity(vx, vy, omega, m.getPosition());
            m.setTargetState(moduleVel);
        }
    }

    /*
     * Since the user will pass in field relative velocities, we need to convert vx, vy, and omega
     * to robot relative velocities for the module to follow!
     * 
     * This is simply done by taking the vector and multiplying it by the rotation matrix.
     * If you've learned about DeMoivre's Theorem and rotating points in the complex plane,
     * it is good to know that this rotation matrix is derived from the expansion of cos(x) + isin(x)
     */
    private PVector calculateModuleVelocity(float vx_field, float vy_field, float omega, PVector pos) {
        // Convert from field coordinates to robot coordinates
        float theta = -1 * radians(robotAngle); // -1 for CW (CCW is +1)
        float vx_robot = vx_field * cos(theta) - vy_field * sin(theta);
        float vy_robot = vx_field * sin(theta) - vy_field * cos(theta);

        // Cross product of omega and R (radius, or distance from center)
        // This gives us the perpendicular, velocity (v = wR) at the module's position
        float omegaRad = radians(omega);
        float rotationalVx = -omegaRad * pos.y;
        float rotationalVy = omegaRad * pos.x;
        
        // Recall that wheel velocity must = Translation + Rotation effect
        return new PVector(vx_robot + rotationalVx, vy_robot + rotationalVy);
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
        robotAngularVelocity = totalOmega / 4;

        // Update robot position and angle
        robotPosition.add(PVector.mult(robotVelocity, DT));
        robotAngle += robotAngularVelocity * DT;
        
        // Normalize robot angle within bounds
        robotAngle = robotAngle % 360;
        if (robotAngle < 0) robotAngle += 360;
    }

    private PVector recalculateLinearAccel(PVector targetAccel) {
        /* TRACTION
         * When the wheels of the drivetrain are touching the ground, they exert a force
         * equal to the mass of the drivetrain multiplied by the gravity constant.
         * 
         * However, due to friction, the actual force exerted by the wheels is less than 
         * F = mg. Instead, it is F = mg * t, where t is the traction coefficient from 0 to 1.
         * 
         * Since we're calculating the max acceleration, we can divide by m on both sides,
         * which gives us gt as the max possible acceleration.
        */
        float maxTraction = wheelTread.getTractionCoefficient();
        float maxAccelMag = maxTraction * 9.81;

        /* MASS (INERTIA)
         * Newton's first law of motion explains why objects tend to stay in equilibrium
         * unless acted upon by an unbalanced force. This is known as inertia.
         * 
         * By Newton's second law F = ma, objects with more mass experience less acceleration 
         * for the same force. So, in our case a heavier robot will be harder to accelerate
         * than a lighter robot.
         */
        float medianRobotMass = 100.0;

        // This factor normalizes the maxAccel of a robot relative to its mass
        float massEffect = 1.0 / (1.0 + mass / medianRobotMass);
        maxAccelMag *= massEffect;

        PVector output = targetAccel;
        if (output.mag() > maxAccelMag) {
            output.normalize();
            output.mult(maxAccelMag);
        }

        return output;
    }

    // GETTERS
    public PVector getRobotPosition() { return robotPosition.copy(); }
    public float getRobotAngle() { return robotAngle; }
    public PVector getRobotVelocity() { return robotVelocity.copy(); }
    public float getRobotAngularVelocity() { return robotAngularVelocity; }

    // Draw robot and modules on canvas!
    public void draw() {
        float s = 8;
        float t = 4;

        pushMatrix();
        translate(robotPosition.x, robotPosition.y); // move coordinate system to center of robot
        rotate(radians(robotAngle)); // rotate coordinate system by angle of robot
        fill(255, 0, 0);
        stroke(0);
        strokeWeight(1);
        
        // draw square representing robot center
        beginShape();
        vertex(-s, s);
        vertex(s, s);
        vertex(s, -s);
        vertex(-s, -s);
        endShape(CLOSE);
        
        fill(0, 255, 0);
        stroke(0);
        strokeWeight(1);
        
        // draw triangle representing robot direction
        beginShape();
        vertex(t, 0);
        vertex(-t/2, t/2);
        vertex(-t/2, -t/2);
        endShape(CLOSE);

        popMatrix();

        for (Module m : modules) {
            m.draw(robotPosition, robotAngle, s, t);
        }
    }

    public PVector getRobotPosition(){
        return robotPosition;
    }
}