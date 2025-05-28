public class SwerveDrive{
    private float gearRatio;
    private WheelTread wheelTread;
    private Module[] modules;
    private PVector driveVelocity;
    private float steerVelocity;

    public SwerveDrive(float gr, Module[] m, WheelTread wt){
        gearRatio = gr;
        modules = m;
        wheelTread = wt;
        driveVelocity = new PVector(0, 0);
        steerVelocity = 0;
    }

    public void updateSpeeds(PVector targetAccel, float targetAngularAccel, float mass, float centerOfGravity, float dt){
        for (Module m : modules) {
            m.update(targetAccel, targetAngularAccel, dt);
        }
    }

    public PVector getVelocity(){
        return currentVelocity;
    }

    public float getAngularVelocity(){
        return currentAngularVelocity;
    }

    public void updateModuleStates(){

    }
}