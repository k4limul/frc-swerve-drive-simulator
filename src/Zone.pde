public class Zone{
    private String name;
    private PVector position;
    private float width, height;
    private int points;

    public Zone(String n, PVector pos, float w, float h, int p){
        name = n;
        position = pos;
        width = w;
        height = h;
        points = p;
    }

    public boolean checkRobotInside(Robot robot){
        PVector robotPos = robot.getPosition();
        return (robotPos.x > position.x - width/2 && robotPos.x < position.x + width/2 
                && robotPos.y > position.y - height/2 && robotPos.y < position.y + height/2);
    }

    public void applyEffect(Robot robot){
        if(checkRobotInside(robot)) {
            if (name.equals("source")) {
                robot.acquireGamePiece();
            } else if (name.equals("stage")) {
                robot.setClimbing(true);
            } else if (name.equals("subwoofer")){
                if(robot.hasGamePiece()) {
                    robot.subwooferShot();
                }
            } else if (name.equals("amp")){
                robot.ampScore();
            }
        } else {
            if (name.equals("stage")) {
                robot.setClimbing(false);
            }
        }
    }

    public String getName() {
      return name;
    }
    
    public void draw(){
    }
}
