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

    public void loadFieldImage(String imagePath) {
        fieldImage = loadImage(imagePath);
    }

    private void setup(){
        ControlScheme p1controls = new ControlScheme('w', 's', 'a', 'd', 'q', 'e');
        ControlScheme p2controls = new ControlScheme('i', 'k', 'j', 'l', 'u', 'o');
 
        Robot blue = new Robot("Blue", 150, WheelTread.SPIKY, new PVector(100, 400), 0, p1controls, scoreBoard);
        Robot red = new Robot("Red", 150, WheelTread.SPIKY, new PVector(500, 400), 180, p2controls, scoreBoard);
        robots.clear();
        robots.add(red);
        robots.add(blue);

        zones.clear();
        zones.add(new Zone("source", new PVector(50,500), 20, 50, 0));
        zones.add(new Zone("stage", new PVector(150,150), 50, 50, 3));
        zones.add(new Zone("subwoofer", new PVector(200,100), 40, 50, 2));
        zones.add(new Zone("amp", new PVector(550,100), 40, 60, 1));
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
        }
        for (Robot r : robots) {
            r.draw();
        }
        scoreBoard.displayScoreBoard();
        if (!gameStarted) {
            drawInstructions();
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
        rect(width/2, height/2, width/2, height/2+50);
        
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
    
    public void handleKeyPressed() {
      if (key == ' ' && !gameStarted && !scoreBoard.getTimer().isFinished()) {
          startGame();
      } else if (key == 'r' || key == 'R') {
          reset();
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
