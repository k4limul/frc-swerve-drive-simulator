public class Robot{
    private String team;
    private float mass;
    private float centerOfGravity;
    private WheelTread wheelTread; 
    private PVector currentVelocity;
    private float currentAngularVelocity;
    private SwerveDrive swerveDrive;
    private ControlScheme controlScheme;

    public Robot(){
        this.team = "";
        this.mass = 0.0;
        this.centerOfGravity = 0/0;
        this.wheelTread = new WheelTread();
        this.currentVelocity = new PVector();
        this.currentAngularVelocity = 0.0;
        this.swerveDrive = new SwerveDrive();
        this.controlScheme = new ControlScheme();
    }

    public Robot(String team, float mass, float centerOfGravity, float centerOfGravity, WheelTread wheelTread, PVector currentVelocity, float currentAngularVelocity, SwerveDrive swerveDrive, ControlScheme controlScheme){
        this.team = team;
        this.mass = mass;
        this.centerOfGravity = centerOfGravity;
        this.wheelTread = wheelTread;
        this.currentVelocity = currentVelocity;
        this.currentAngularVelocity = currentAngularVelocity;
        this.swerveDrive = swerveDrive;
        this.controlScheme = controlScheme;
    }

    public void updateSwerveState(){

    }
    public void moveRobot(){

    }
    public void updateZoneState(){

    }
    public void updateScoreBoard(){

    }
    public void draw(){
        
    }
    
}