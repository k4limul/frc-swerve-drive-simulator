public class WheelTread {
    private float traction;
    private float pointModifier;

    public WheelTread(){
        this.traction = 0;
        this.pointModifier = 0;
    }

    public WheelTread(float traction, float pointModifier){
        this.traction = traction;
        this.pointModifier = pointModifier;
    }

    public float getTraction(){
        return traction;
    }
    public float getPointModifier(){
        return pointModifier;
    }
}