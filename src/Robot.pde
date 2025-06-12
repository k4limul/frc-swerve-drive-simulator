public class Robot{
    private String team;
    private int mass;
    private WheelTread wheelTread;
    private SwerveDrive swerveDrive;
    private ControlScheme controlScheme;
    private ScoreBoard scoreBoard;
    private boolean climbing;
    private boolean climbed;
    private boolean gamePiece;
    private String zone;
    private boolean amplified;

    public Robot(String team, int mass, WheelTread wheelTread, PVector startPos, float startAngle, ControlScheme controlScheme, ScoreBoard scoreBoard) {
        this.team = team;
        this.mass = mass;
        this.wheelTread = wheelTread;
        this.controlScheme = controlScheme;
        this.scoreBoard = scoreBoard;

        climbing = false;
        climbed = false;
        gamePiece = true; // starts with a gamepiece
        amplified = false;

        Module[] modules = new Module[4];
        modules[0] = new Module(new PVector(15, 15), 2000, 360);   // Front Right
        modules[1] = new Module(new PVector(-15, 15), 2000, 360);  // Front Left  
        modules[2] = new Module(new PVector(-15, -15), 2000, 360); // Back Left
        modules[3] = new Module(new PVector(15, -15), 2000, 360);  // Back Right
        
        this.swerveDrive = new SwerveDrive(startPos, startAngle, modules, mass, wheelTread);
    }

    public void updateSwerveState() {
        if (climbed) {
            swerveDrive.drive(0, 0, 0);
        } else {
            PVector translation = controlScheme.getTranslationInput(300);
            float rotation = controlScheme.getRotationInput(180);
            
            swerveDrive.drive(translation.x, translation.y, rotation);
        }
        swerveDrive.update();
        updateShotState();
        updateClimbState();
    }

    public void updateShotState() {
        if (controlScheme.isShootKeyPressed() && gamePiece && canShootIntoZone()) {
            shoot();
        }
    }

    public void updateClimbState() {
        if (controlScheme.isClimbKeyPressed() && zone != null && zone.equals("stage") && climbed == false) {
            climb();
            climbed = true;
        }
    }
    
    private boolean canShootIntoZone() {
        if (zone == null) return false;

        float angle = getAngle();

        if (team.equals("Blue")) {
            if (zone.equals("subwoofer")) {
                return angle >= 90 && angle <= 270;
            } else if (zone.equals("amp")) {
                return angle >= 225 && angle <= 315; // facing north is 270 deg
            }
        } else { // Red alliance
            if (zone.equals("subwoofer")) {
                // We can't check if an angle is between 270 and 90 going counterclockwise in one statement, so:
                return (angle >= 270 && angle <= 360) || (angle >= 0 && angle <= 90);
            } else if (zone.equals("amp")) {
                return angle >= 225 && angle <= 315; // facing north is 270 deg
            }
        }
        return false;
    }
    
    private void shoot() {
        if (!gamePiece) return;

        gamePiece = false;
        
        if (zone.equals("subwoofer")) {
            int points = 2;
            int multiplier = amplified ? 2 : 1; // 2x if amplified
            updateScoreBoard(points * multiplier);
            if (amplified) amplified = false;
        } else if (zone.equals("amp")) {
            updateScoreBoard(1);
            amplified = true;
        }
    }

    private void climb() {
        if (!climbing) {
            climbing = true;
            updateScoreBoard(6);
        }
    }

    public void updateZoneState(String name){
        zone = name;
    }
    
    public void updateScoreBoard(int points){
        scoreBoard.addPoints(team, points, wheelTread.getPointModifier() * getMassPointModifier());
    }

    private float getMassPointModifier() {
        if (mass < 100) {
            return 0.9;
        } else if (mass < 150) {
            return 1.0;
        } else {
            return 1.5;
        }
    }

    public PVector getPosition() {
        return swerveDrive.getRobotPosition();
    }
    
    public float getAngle() {
        return swerveDrive.getRobotAngle();
    }

    public String getTeam() {
        return team;
    }
    
    public ControlScheme getControlScheme() {
        return controlScheme;
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

    public void draw(){
        if (team.equals("Blue")) {
            swerveDrive.draw(true);
        } else {
            swerveDrive.draw(false);
        }
        
        // Draw gamepiece (orange donut-shaped "note")
        if (gamePiece) {
            PVector pos = swerveDrive.getRobotPosition();
            pushMatrix();
            translate(pos.x, pos.y);
            stroke(255, 140, 0);
            strokeWeight(2);
            ellipse(0, 0, 15, 15);
            popMatrix();
        }
    }
}
