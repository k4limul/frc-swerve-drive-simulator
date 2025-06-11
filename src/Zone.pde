public class Zone{
    private String name;
    private PVector position;
    private float width, height;
    private int points;
    private String team;

    public Zone(String n, PVector pos, float w, float h, int p, String t){
        name = n;
        position = pos;
        width = w;
        height = h;
        points = p;
        team = t;
    }

    public boolean checkRobotInside(Robot robot){
        PVector robotPos = robot.getPosition();
        return (robotPos.x > position.x - width/2 && robotPos.x < position.x + width/2 
                && robotPos.y > position.y - height/2 && robotPos.y < position.y + height/2);
    }

    public void applyEffect(Robot robot){
        if(checkRobotInside(robot)) {
            if (name.equals("source")) {
                if (robot.getTeam().equals(team) && !robot.hasGamePiece()) {
                    robot.acquireGamePiece();
                }
            } else if (name.equals("stage")) {
                robot.setClimbing(true);
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
        if (name.equals("source")) {
            fill(0, 255, 0, 50);
            stroke(0, 255, 0);
        } else if (name.equals("stage")) {
            fill(255, 255, 0, 50);
            stroke(255, 255, 0);
        } else if (name.equals("subwoofer")) {
            fill(255, 0, 255, 50);
            stroke(255, 0, 255);
        } else if (name.equals("amp")) {
            fill(0, 255, 255, 50);
            stroke(0, 255, 255);
        }
        
        strokeWeight(2);
        rectMode(CENTER);
        rect(position.x, position.y, width, height);
        
        fill(255);
        textAlign(CENTER, CENTER);
        textSize(10);
        text(name.toUpperCase(), position.x, position.y);
        rectMode(CORNER);
    }
}
