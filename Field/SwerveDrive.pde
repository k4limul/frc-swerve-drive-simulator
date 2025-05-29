public class SwerveDrive{
    private float gearRatio;
    private WheelTread wheelTread;
    private float mass;
    private Module[] modules;

    private PVector robotPosition;
    private float robotAngle;
    private PVector robotVelocity;
    private float robotAngularVelocity;

    public SwerveDrive(float gearRatio, WheelTread wheelTread, float mass, Module[] modules, PVector startPos, float startAngle){
        this.gearRatio = gearRatio;
        this.wheelTread = wheelTread;
        this.mass = mass;
        this.modules = modules;

        robotPosition = startPos;
        robotAngle = startAngle;
        robotVelocity = new PVector(0, 0);
        robotAngularVelocity = 0;
    }

    public void updateModuleStates(PVector accel, float angularAccel, float dt){
        for (Module m : modules) {
            PVector recalculatedAccel = recalculateLinearAccel(accel);
            m.update(recalculatedAccel, angularAccel, dt);
        }

        updateRobotState();
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

    private void updateRobotState(){
        PVector avgVelocity = new PVector(0, 0);
        PVector avgPosition = new PVector(0, 0);
        float avgAngle = 0;

        for (Module m : modules) {
            avgVelocity.add(m.getVelocity());
            avgPosition.add(m.getPosition());
            avgAngle += m.getAngle();
        }

        avgVelocity.div(modules.length);
        avgPosition.div(modules.length);
        avgAngle /= modules.length;

        robotVelocity = avgVelocity;
        robotPosition = avgPosition;
        robotAngle = avgAngle;
        // need to figure out how to implement angular velocity update
    }

    public PVector getVelocity(){
        return robotVelocity;
    }

    public float getAngularVelocity(){
        return robotAngularVelocity;
    }
}