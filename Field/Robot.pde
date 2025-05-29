public class Robot{
    private String team;
    private float mass;
    private float centerOfGravity;
    private WheelTread wheelTread; 
    private PVector currentVelocity;
    private float currentAngularVelocity;
    private SwerveDrive swerveDrive;
    private ControlScheme controlScheme;
    private boolean climbing;
    private boolean gamePiece;
    private String zone;

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

    public Robot(String team, float mass, float centerOfGravity, WheelTread wheelTread, PVector currentVelocity, float currentAngularVelocity, SwerveDrive swerveDrive, ControlScheme controlScheme){
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
        // if(ControlScheme.isUpPressed()) { SwerveDrive.updateModuleStates(new PVector(0,1), 0, 0.01 ); } // update with real values
    }

    public void moveRobot(){
        
    }

    public void updateZoneState(String name){
        zone = name;
    }
    
    public void updateScoreBoard(int points){
        ScoreBoard.addPoints(team, points);
    }

    public PVector getPosition(){
        return swerveDrive.getPosition();
    }

    public void getGamePieces(){
        gamePiece = true;
    }

    public void setClimbing(boolean climb){
        climbing = climb;
    }

    public boolean hasGamePiece(){
        return gamePiece;
    }

    public void subwooferShot(){
        gamePiece = false;
        updateScoreBoard(2);
    }

    public void draw(){
        
    }
    
}