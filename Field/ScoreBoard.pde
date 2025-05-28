public class ScoreBoard {
    private int redScore = 0;
    private int blueScore = 0;
    private String redName = "Red";
    private String blueName = "Blue";
    private Timer timer = new timer();

    public ScoreBoard(String redName, String blueName) {
        this.redName = redName;
        this.blueName = blueName;
    }

    public void addPoints(String team, int points){
        if (team.equals(redName)) {
            redScore += points;
        } else if(team.equals(blueName)) {
            blueScore += points;
        } else{
            throw new IllegalArguementException("Team Does not Exist");
        }
    }

    public int getRedScore() {
        return redScore;
    }

    public int getBlueScore() {
        return blueScore;
    }

    // unfinished
    public void update();
    public void displayScoreBoard();
}