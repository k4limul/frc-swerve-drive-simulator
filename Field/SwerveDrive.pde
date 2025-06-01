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
    private PVector previousVelocity;
    private float previousAngularVelocity;

    private WheelTread wheelTread;
    private float mass;

    public SwerveDrive(PVector startPos, float startAngle, Module[] modules, float mass, WheelTread wheelTread) {
        robotPosition = startPos;
        robotAngle = startAngle;
        robotVelocity = new PVector(0, 0);
        robotAngularVelocity = 0;

        robotAcceleration = new PVector(0, 0);
        robotAngularAcceleration = 0;
        previousVelocity = new PVector(0, 0);
        previousAngularVelocity = 0;

        this.modules = modules;
        this.mass = mass;
        this.wheelTread = wheelTread;
    }

    // Called every frame in main class to update the robot's states
    public void update() {
        previousVelocity = robotVelocity.copy();
        previousAngularVelocity = robotAngularVelocity;
        
        for (Module m : modules) {
            m.update(DT);
        }
        
        robotAcceleration = PVector.sub(robotVelocity, previousVelocity).div(DT);
        robotAngularAcceleration = (robotAngularVelocity - previousAngularVelocity) / DT;
        
        // Update position based on velocity
        robotPosition.add(PVector.mult(robotVelocity, DT));
        robotAngle += robotAngularVelocity * DT;
    }

    // Called with keyboard inputs
    public void drive(float vx, float vy, float targetOmega) {
        PVector linAccel = recalculateLinearAccel(PVector.sub(new PVector(vx, vy), robotVelocity).div(60));
        PVector targetVelocity = PVector.add(linAccel.mult(DT), robotVelocity);
        for (Module m : modules) {
            calculateModuleVelocity(targetVelocity.x, targetVelocity.y, targetOmega, m.getPosition());
            m.setTargetState(targetVelocity);
        }
    }

    private PVector calculateModuleVelocity(float vx, float vy, float omega, PVector pos) {
        // Module velocity = chassis translation + rotation effect
        float omegaRad = radians(omega);

        // omega × r (cross product) gives perpendicular velocity
        float rotationalVx = -omegaRad * pos.y;
        float rotationalVy = omegaRad * pos.x;
        
        return new PVector(vx + rotationalVx, vy + rotationalVy);
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