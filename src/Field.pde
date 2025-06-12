public class Field {
    private ArrayList<Robot> robots;
    private ArrayList<Zone> zones;
    private ScoreBoard scoreBoard;
    private PImage fieldImage;
    private boolean gameStarted;


    public Field() {
        robots = new ArrayList<Robot>();
        zones = new ArrayList<Zone>();
        scoreBoard = new ScoreBoard("Red", "Blue");
        gameStarted = false;

        setup();
    }

    public ScoreBoard getScoreBoard(){
        return this.scoreBoard;
    }

    public void loadFieldImage(String imagePath) {
        fieldImage = loadImage(imagePath);
    }

    private void setup(){
        ControlScheme p1controls = new ControlScheme('w', 's', 'a', 'd', 'e', 'q', 'f', 'z', 'x', 'c');
        ControlScheme p2controls = new ControlScheme('i', 'k', 'j', 'l', 'o', 'u', 'h', 'm', 'n', 'b');
 
        Robot blue = new Robot("Blue", 40, WheelTread.SPIKY, new PVector(450, 400), 0, p1controls, scoreBoard, 2, 1);
        Robot red = new Robot("Red", 150, WheelTread.SMOOTH, new PVector(590, 400), 180, p2controls, scoreBoard, 2, 1);
        robots.clear();
        robots.add(red);
        robots.add(blue);

        zones.clear();
        zones.add(new Zone("source", new PVector(80,500), 120, 50, 0, "Blue", 5*PI/24));
        zones.add(new Zone("source", new PVector(80,100), 120, 50, 0, "Blue", 19*PI/24));
        zones.add(new Zone("reefAB", new PVector(215,300), 40, 50, 1, "Blue", 0));
        zones.add(new Zone("reefCD", new PVector(250,360), 40, 40, 1, "Blue", 7*PI/6));
        zones.add(new Zone("reefEF", new PVector(310,360), 40, 40, 1, "Blue", 11*PI/6));
        zones.add(new Zone("reefGH", new PVector(340,300), 40, 50, 1, "Blue", 0));
        zones.add(new Zone("reefIJ", new PVector(310,240), 40, 40, 1, "Blue", PI/6));
        zones.add(new Zone("reefKL", new PVector(250,240), 40, 40, 1, "Blue", 5*PI/6));
        zones.add(new Zone("processor", new PVector(370,550), 40, 40, 1, "Blue", 0));
        zones.add(new Zone("net", new PVector(460,180), 40, 200, 1, "Blue", 0));

        
        zones.add(new Zone("source", new PVector(960,100), 120, 50, 0, "Red", 5*PI/24));
        zones.add(new Zone("source", new PVector(960,500), 120, 50, 0, "Red", 19*PI/24));
        zones.add(new Zone("reefAB", new PVector(835,300), 40, 50, 1, "Red", 0));
        zones.add(new Zone("reefCD", new PVector(800,240), 40, 40, 1, "Red", 7*PI/6));
        zones.add(new Zone("reefEF", new PVector(740,240), 40, 40, 1, "Red", 11*PI/6));
        zones.add(new Zone("reefGH", new PVector(710,300), 40, 50, 1, "Red", 0));
        zones.add(new Zone("reefIJ", new PVector(740,360), 40, 40, 1, "Red", PI/6));
        zones.add(new Zone("reefKL", new PVector(800,360), 40, 40, 1, "Red", 5*PI/6));
        zones.add(new Zone("processor", new PVector(680,60), 40, 40, 1, "Red", 0));
        zones.add(new Zone("net", new PVector(590,180), 40, 200, 1, "Red", 0));
    }

    public void update() {
        if (!gameStarted) return;
        scoreBoard.update();

        for (Robot r : robots) {
            r.updateSwerveState();
            updateZoneState(r);
        }
    }

    public void draw() {
        image(fieldImage, 0, 0, width, height);
        for (Zone z : zones) {
            z.draw();
            z.applyEffect(robots.get(0));
            z.applyEffect(robots.get(1));
        }
        for (Robot r : robots) {
            r.draw();
        }
        scoreBoard.displayScoreBoard();
        if (!gameStarted) {
            drawInstructions();
        }
        if (scoreBoard.timer.isFinished()){
            background(51);
        }
    }

    public void updateZoneState(Robot r) {
        for (Zone z : zones) {
            if (z.checkRobotInside(r)) 
                r.updateZoneState(z.getName());
        }
    }

    public void startGame() {
        gameStarted = true;
        scoreBoard.startMatch();
    }

    public void endGame() {
        gameStarted = false;
    }

    private void drawInstructions() {
        fill(0, 0, 0, 150);
        rectMode(CENTER);
        rect(width/2, height/2, width/2+120, height/2+50);
        rectMode(CORNER);
        
        fill(255);
        textAlign(CENTER);
        textSize(18);
        text("FRC Swerve Drive Simulator", width/2, height/2 - 100);
        text("Player 1 (Blue): WASD to move, E/Q to rotate, F to shoot \n", width/2, height/2 - 50);
        text("Player 2 (Red): IJKL to move, O/U to rotate, H to shoot \n", width/2, height/2 - 25);
        text("Drive to your alliance's source zone to pickup gamepieces \n", width/2, height/2);
        text("Drive back to your speaker or amp, then shoot to score! \n", width/2, height/2 + 25);
        textSize(18);
        text("Press SPACE to start the match!", width/2, height/2 + 160);
    }
    
    public void handleKeyPressed(char key, int keyCode) {
      if (key == ' ' && !gameStarted && !scoreBoard.getTimer().isFinished()) {
          startGame();
      } else if (key == 'r' || key == 'R') {
          reset();
      }

      for (Robot r : robots) {
        r.getControlScheme().keyPressed(key, keyCode);
      }
    }

    public void handleKeyReleased(char key, int keyCode) {
        for (Robot r : robots) {
            r.getControlScheme().keyReleased(key, keyCode);
        }
    }

    public void reset() {
        robots.clear();
        zones.clear();
        scoreBoard = new ScoreBoard("Red", "Blue");
        gameStarted = false;
        setup();
    }
}