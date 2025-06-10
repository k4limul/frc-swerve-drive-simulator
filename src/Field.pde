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
        ControlScheme p1controls = new ControlScheme('w', 's', 'a', 'd', 'q', 'e');
        ControlScheme p2controls = new ControlScheme('i', 'k', 'j', 'l', 'u', 'o');
 
        Robot blue = new Robot("Blue", 40, WheelTread.SPIKY, new PVector(100, 400), 0, p1controls, scoreBoard);
        Robot red = new Robot("Red", 150, WheelTread.SMOOTH, new PVector(700, 400), 180, p2controls, scoreBoard);
        robots.clear();
        robots.add(red);
        robots.add(blue);

        zones.clear();
        zones.add(new Zone("source", new PVector(750,550), 100, 100, 0));
        zones.add(new Zone("stage", new PVector(230,301), 80, 80, 3));
        zones.add(new Zone("subwoofer", new PVector(85,195), 80, 80, 2));
        zones.add(new Zone("amp", new PVector(100,40), 80, 80, 1));
        
        zones.add(new Zone("source", new PVector(50,550), 100, 100, 0));
        zones.add(new Zone("stage", new PVector(570,301), 80, 80, 3));
        zones.add(new Zone("subwoofer", new PVector(715,195), 80, 80, 2));
        zones.add(new Zone("amp", new PVector(700,40), 80, 80, 1));
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
        textSize(24);
        text("FRC Swerve Drive Simulator", width/2, height/2 - 100);
        text("Player 1 (Blue): WASD to move, Q/E to rotate", width/2, height/2 - 40);
        text("Player 2 (Red): IJKL to move, U/O to rotate", width/2, height/2 - 20);
        textSize(18);
        text("", width/2, height/2);
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
