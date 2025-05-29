void setup(){
    private List<Robot> robots = new List<>();
    private List<Zone> zones = new List<>();
    private ScoreBoard = new ScoreBoard(15, 135);

    Robot blue = new Robot("blue", 115, 20, )
    Zone source = new Zone("source", new PVector(50,500), 20, 50, 0);
    zones.add(source);
    Zone stage = new Zone("stage", new PVector(150,150), 50, 50, 3);
    zones.add(stage);
    Zone subwoofer = new Zone("subwoofer", new PVector(200,100), 40, 50, 2);
    zones.add(subwoofer);
}

void draw(){
    ScoreBoard.displayScoreBoard();
}
void update(){
    ScoreBoard.update();
}
void reset(){
    setup();
}
void startGame(){
    ScoreBoard.startMatch();
}
void endGame(){

}

public void updateZoneState(Robot robot){
    for(Zone z: zones){
        if(z.checkRobotInside(robot)) 
            robot.updateZoneState(z.getName());
    }
}