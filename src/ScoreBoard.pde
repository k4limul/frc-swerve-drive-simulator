public class ScoreBoard {
    private int redScore = 0;
    private int blueScore = 0;
    private String redName = "Red";
    private String blueName = "Blue";
    private Timer timer;
    private int boardWidth = 200;
    private int boardHeight = 100;
    private int x, y;

    public ScoreBoard(String redName, String blueName, int x, int y) {
        this.redName = redName;
        this.blueName = blueName;
        this.x = x;
        this.y = y;
        this.timer = new Timer();
    }

    public void addPoints(String team, int points) {
        if (team.equals(redName)) {
            redScore += points;
        } 
        else if (team.equals(blueName)) {
            blueScore += points;
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

    public void displayScoreBoard() {
        fill(200);
        rect(x, y, boardWidth, boardHeight);

        fill(255, 0, 0);
        text(redName + ": " + redScore, x + 10, y + 30);
        
        fill(0, 0, 255);
        text(blueName + ": " + blueScore, x + 10, y + 60);
        
        fill(0);
        text("Time: " + timer.getTimeLeft(), x + 10, y + 90);
        
        String period;
        if(timer.isAutoFinished == false){
            period = "AUTO";
        }
        else if (timer.isTeleopFinished == false){
            period = "TELEOP";
        }
        else period = "END";
        text(period, x + boardWidth - 80, y + 90);
    }
}