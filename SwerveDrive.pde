public class SwerveDrive{
    private float gearRatio;
    private Module[] moduleStates;
    private PVector currentVelocity;
    private float currentAngularVelocity;

    public SwerveDrive(float g, Module[] m, PVector c, float aV){

    }

    public void updateSpeeds(PVector targetVelocity, float targetAngularVelocity, float mass, float centerOfGravity, float traction){

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