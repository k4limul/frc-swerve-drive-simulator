public class Robot{
    private String team;
    private float mass;
    private WheelTread wheelTread;
    private SwerveDrive swerveDrive;
    private ControlScheme controlScheme;
    private boolean climbing;
    private boolean gamePiece;
    private String zone;

    public Robot(String team, float mass, WheelTread wheelTread, SwerveDrive swerveDrive, PVector startPos, float startAngle, ControlScheme controlScheme, ScoreBoard scoreBoard) {
        this.team = team;
        this.mass = mass;
        this.wheelTread = wheelTread;
        this.controlScheme = controlScheme;
        this.scoreBoard = scoreBoard;

        this.climbing = false;
        this.gamePiece = true; // starts with a gamepiece
        this.currentZone = "";

        Module[] modules = new Module[4];
        modules[0] = new Module(new PVector(15, 15), 200, 360);   // Front Right
        modules[1] = new Module(new PVector(-15, 15), 200, 360);  // Front Left  
        modules[2] = new Module(new PVector(-15, -15), 200, 360); // Back Left
        modules[3] = new Module(new PVector(15, -15), 200, 360);  // Back Right
        
        this.swerveDrive = new SwerveDrive(startPos, startAngle, modules, mass, wheelTread);
    }

    public void updateSwerveState() {
        PVector translation = controlScheme.getTranslationInput();
        float rotation = controlScheme.getRotationInput();

        swerveDrive.drive(translation.x, translation.y, rotation);
        swerveDrive.update();
    }

    public void updateZoneState(String name){
        zone = name;
    }
    
    public void updateScoreBoard(int points){
        ScoreBoard.addPoints(team, points);
    }

    public PVector getPosition() {
        return swerveDrive.getRobotPosition();
    }
    
    public void acquireGamePiece(){
        gamePiece = true;
    }

    public void setClimbing(boolean climb){
        climbing = climb;
    }

    public boolean hasGamePiece(){
        return gamePiece;
    }

    public void ampScore(){
        if (gamePiece) {
            gamePiece = false;
            updateScoreBoard(1);
        }
    }

    public void subwooferShot(){
        if (gamePiece) {
            gamePiece = false;
            updateScoreBoard(2);
        }
    }

    public void draw(){
        swerveDrive.draw();
    }
    
}