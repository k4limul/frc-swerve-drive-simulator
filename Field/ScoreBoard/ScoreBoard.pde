public class ScoreBoard {
    private int redScore = 0;
    private int blueScore = 0;
    private String redName = "Red";
    private String blueName = "Blue";
    privater Timer timer = new timer();

    public ScoreBoard(String redName, String blueName) {
        this.redName = redName;
        this.blueName = blueName;
    }
    public void addPoints(String team, int points){
        if(team.equals("RED")){
            redScore += points;
        }
        else if(team.equals("BLUE")){
            blueScore += points;
        }
        else{
            throw new IllegalArguementException("Team Does not Exist");
        }
    }
    public void update();
    public void displayScoreBoard();
}