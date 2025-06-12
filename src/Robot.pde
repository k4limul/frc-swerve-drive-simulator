public class Robot{
    private String team;
    private int mass;
    private WheelTread wheelTread;
    private SwerveDrive swerveDrive;
    private ControlScheme controlScheme;
    private ScoreBoard scoreBoard;
    private boolean climbing;
    private boolean coral;
    private boolean algae;
    private String zone;
    private int currentLevel;
    private int leftright; // 0 = left, 1 = right
    private boolean[] level2;
    private boolean[] level3;
    private boolean[] level4;
    private boolean[] reefAlgae;
    private int side;

    public Robot(String team, int mass, WheelTread wheelTread, PVector startPos, float startAngle, ControlScheme controlScheme, ScoreBoard scoreBoard, int level, int leftright) {
        this.team = team;
        this.mass = mass;
        this.wheelTread = wheelTread;
        this.controlScheme = controlScheme;
        this.scoreBoard = scoreBoard;

        climbing = false;
        coral = true; // starts with a gamepiece
        algae = false;
        currentLevel = level;
        this.leftright = leftright;
        level2 = new boolean[12];
        level3 = new boolean[12];
        level4 = new boolean[12];
        reefAlgae = new boolean[6];

        Module[] modules = new Module[4];
        modules[0] = new Module(new PVector(15, 15), 2000, 360);   // Front Right
        modules[1] = new Module(new PVector(-15, 15), 2000, 360);  // Front Left  
        modules[2] = new Module(new PVector(-15, -15), 2000, 360); // Back Left
        modules[3] = new Module(new PVector(15, -15), 2000, 360);  // Back Right
        
        this.swerveDrive = new SwerveDrive(startPos, startAngle, modules, mass, wheelTread);
    }

    public void updateSwerveState() {
        PVector translation = controlScheme.getTranslationInput(300);
        float rotation = controlScheme.getRotationInput(180);

        swerveDrive.drive(translation.x, translation.y, rotation);
        swerveDrive.update();
        updateShotState();
        updateLevel();
        updateLR();
        updateAlgae();
        controlScheme.updateKeyStates();
    }

    public void updateShotState() {
        if (controlScheme.isShootKeyPressed() && coral && canShootIntoZone()) {
            shoot();
        }
    }

    public void updateLevel(){
        if(controlScheme.isLevelShiftKeyPressed()){
            currentLevel++;
            if(currentLevel >= 5) { currentLevel = 2;}
        }
    }

    public void updateAlgae(){
        if(controlScheme.isAlgaeKeyPressed() && (zone.equals("reefAB") || zone.equals("reefCD") || zone.equals("reefEF") || zone.equals("reefGH") || zone.equals("reefIJ") || zone.equals("reefKL"))) {
            if(!algae && !reefAlgae[side - 1]){
                algae = true;
                reefAlgae[side - 1] = true;
            }
        } else if (controlScheme.isAlgaeKeyPressed() && zone.equals("processor") && algae){
            algae = false;
            updateScoreBoard(2);
        } else if (controlScheme.isAlgaeKeyPressed() && zone.equals("net") && algae){
            algae = false;
            updateScoreBoard(4);
        }
    }

    public void updateLR(){
        if(controlScheme.isLRShiftKeyPressed()){
            leftright = (leftright + 1) % 2;
        }
    }
    
    private boolean canShootIntoZone() {
        if (zone == null) return false;

        float angle = getAngle();

        if (team.equals("Blue")) {
            boolean isEmpty;
            if (zone.equals("reefAB")) {
                isEmpty = true;
                if(currentLevel == 2){ isEmpty = !level2[(side - 1) * 2 + leftright]; }
                if(currentLevel == 3){ isEmpty = !level3[(side - 1) * 2 + leftright]; }
                if(currentLevel == 4){ isEmpty = !level4[(side - 1) * 2 + leftright]; }
                return (angle >= 335 || angle <= 25) && isEmpty;
            } else if(zone.equals("reefCD")){
                isEmpty = true;
                if(currentLevel == 2){ isEmpty = !level2[(side - 1) * 2 + leftright]; }
                if(currentLevel == 3){ isEmpty = !level3[(side - 1) * 2 + leftright]; }
                if(currentLevel == 4){ isEmpty = !level4[(side - 1) * 2 + leftright]; }
                return angle >= 290 && angle <= 340 && isEmpty;
            } else if(zone.equals("reefEF")){
                isEmpty = true;
                if(currentLevel == 2){ isEmpty = !level2[(side - 1) * 2 + leftright]; }
                if(currentLevel == 3){ isEmpty = !level3[(side - 1) * 2 + leftright]; }
                if(currentLevel == 4){ isEmpty = !level4[(side - 1) * 2 + leftright]; }
                return angle >= 200 && angle <= 250 && isEmpty;
            } else if(zone.equals("reefGH")){
                isEmpty = true;
                if(currentLevel == 2){ isEmpty = !level2[(side - 1) * 2 + leftright]; }
                if(currentLevel == 3){ isEmpty = !level3[(side - 1) * 2 + leftright]; }
                if(currentLevel == 4){ isEmpty = !level4[(side - 1) * 2 + leftright]; }
                return angle >= 155 && angle <= 205 && isEmpty;
            } else if(zone.equals("reefIJ")){
                isEmpty = true;
                if(currentLevel == 2){ isEmpty = !level2[(side - 1) * 2 + leftright]; }
                if(currentLevel == 3){ isEmpty = !level3[(side - 1) * 2 + leftright]; }
                if(currentLevel == 4){ isEmpty = !level4[(side - 1) * 2 + leftright]; }
                return angle >= 110 && angle <= 160 && isEmpty;
            } else if(zone.equals("reefKL")){
                isEmpty = true;
                if(currentLevel == 2){ isEmpty = !level2[(side - 1) * 2 + leftright]; }
                if(currentLevel == 3){ isEmpty = !level3[(side - 1) * 2 + leftright]; }
                if(currentLevel == 4){ isEmpty = !level4[(side - 1) * 2 + leftright]; }
                return angle >= 20 && angle <= 70 && isEmpty;
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
        if (!coral) return;

        coral = false;
        
        if (zone.equals("reefAB") || zone.equals("reefCD") || zone.equals("reefEF") || zone.equals("reefGH") || zone.equals("reefIJ") || zone.equals("reefKL")) {
            if(currentLevel == 2){ level2[(side - 1) * 2 + leftright] = true; }
            if(currentLevel == 3){ level3[(side - 1) * 2 + leftright] = true; }
            if(currentLevel == 4){ level4[(side - 1) * 2 + leftright] = true; }
            updateScoreBoard(currentLevel + 1);
        } else if (zone.equals("amp")) {
            updateScoreBoard(1);
            //amplified = true;
        }
    }


    public void updateZoneState(String name){
        zone = name;
        if(zone.equals("reefAB")) side = 1;
        if(zone.equals("reefCD")) side = 2;
        if(zone.equals("reefEF")) side = 3;
        if(zone.equals("reefGH")) side = 4;
        if(zone.equals("reefIJ")) side = 5;
        if(zone.equals("reefKL")) side = 6;
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

    //public int getLevel(){
    //    return currentLevel;
    //}

    //public boolean hasAlgae(){
    //    return algae;
    //}

    //public int getleftright(){
    //    return leftright;
    //}

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
    
    public void acquireCoral(){
        coral = true;
    }

    public void setClimbing(boolean climb){
        climbing = climb;
    }

    public boolean hasCoral(){
        return coral;
    }

    

    public void draw(){
        if (team.equals("Blue")) {
            swerveDrive.draw(true);
        } else {
            swerveDrive.draw(false);
        }
        
        // Draw gamepiece (orange donut-shaped "note")
        if (coral) {
            PVector pos = swerveDrive.getRobotPosition();
            pushMatrix();
            translate(pos.x, pos.y);
            if(currentLevel == 2) stroke(255, 0, 0);
            if(currentLevel == 3) stroke(0, 255, 0);
            if(currentLevel == 4) stroke(0, 0, 255);
            strokeWeight(2);
            rect(-5, 10, 10, 15);
            popMatrix();
        }
        if (algae) {
            PVector pos = swerveDrive.getRobotPosition();
            pushMatrix();
            translate(pos.x, pos.y);
            stroke(0, 255, 255);
            strokeWeight(2);
            ellipse(0, -8, 10, 10);
            popMatrix();
        }
    }
}
