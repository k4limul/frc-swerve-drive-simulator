Field gameField;

void setup() {
    size(800, 600);
    gameField = new Field();
    gameField.loadFieldImage("crescendo.png");
}

void draw() {
    gameField.update();
    gameField.draw();
    if (gameField.getScoreBoard().getTimer().isFinished()) {
        fill(0, 200);
        rect(0, 0, width*2, height*2);
        textAlign(CENTER, CENTER);
        textSize(48);
        fill(255);
        text("MATCH ENDED", width/2, height/4);
        textSize(24);
        int redScore = gameField.getScoreBoard().getRedScore();
        int blueScore = gameField.getScoreBoard().getBlueScore();
        fill(255, 0, 0);
        text("Red Alliance: " + redScore, width/2, height/2 - 40);
        fill(0, 0, 255);
        text("Blue Alliance: " + blueScore, width/2, height/2);
        fill(255);
        String winner;
        if (redScore > blueScore) {
            winner = "Red Alliance Wins!";
        } else if (blueScore > redScore) {
            winner = "Blue Alliance Wins!";
        } else {
            winner = "It's a Tie!";
        }
        text(winner, width/2, height/2 + 60);
        textSize(24);
        fill(200);
        text("Press 'R' to restart match", width/2, height - 50);
    }
}

void keyPressed() {
    if (key == 'r' || key == 'R') {
        gameField.reset();
    } else {
        gameField.handleKeyPressed(key, keyCode);
    }
}

void keyReleased() {
    gameField.handleKeyReleased(key, keyCode);
}
