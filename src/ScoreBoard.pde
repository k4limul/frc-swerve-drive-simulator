public class ScoreBoard {
    private int redScore = 0;
    private int blueScore = 0;
    private String redName = "Red";
    private String blueName = "Blue";
    private Timer timer;
    private int boardWidth = 320;
    private int boardHeight = 100;

    public ScoreBoard(String redName, String blueName) {
        this.redName = redName;
        this.blueName = blueName;
        this.timer = new Timer();
    }

    public void addPoints(String team, int points, float pointMod) {
        if (team.equals(redName)) {
            redScore += Math.ceil(points * pointMod);
        } 
        else if (team.equals(blueName)) {
            blueScore += Math.ceil(points * pointMod);
        } 
        else {
            throw new IllegalArgumentException("Team does not exist");
        }
    }

    public int getRedScore() {
        return redScore;
    }

    public int getBlueScore() {
        return blueScore;
    }

    public void startMatch() {
        timer.start();
    }

    public void update() {
        timer.update();
    }
    
    public Timer getTimer() {
        return timer;
    }

    public void displayScoreBoard() {
        int x = (width - boardWidth) / 2;
        int y = 10;
        
        fill(30, 30, 35, 220);
        stroke(100, 150, 255);
        strokeWeight(2);
        rect(x, y, boardWidth, boardHeight, 8);
        
        fill(50, 50, 60, 100);
        rect(x + 5, y + 5, boardWidth - 10, boardHeight - 10, 5);
        
        textAlign(LEFT);
        PFont scoreFont = createFont("Arial Bold", 16);
        textFont(scoreFont);
        
        fill(255, 80, 80);
        text(redName + ": " + redScore, x + 20, y + 30);
        
        fill(80, 150, 255);
        text(blueName + ": " + blueScore, x + 20, y + 50);
        
        fill(255, 255, 255);
        text("Time: " + timer.getTimeLeft(), x + 20, y + 70);
        
        // Game period indicator
        String period;
        if(timer.isAutoFinished == false){
            period = "AUTO";
            fill(255, 200, 0);
        }
        else if (timer.isTeleopFinished == false){
            period = "TELEOP";
            fill(0, 255, 100);
        }
        else {
            period = "END";
            fill(255, 100, 100);
        }
        
        textAlign(RIGHT);
        text(period, x + boardWidth - 20, y + 30);
        
        stroke(150, 150, 150);
        strokeWeight(1);
        line(x + 15, y + 35, x + boardWidth - 15, y + 35); 
    }

}
