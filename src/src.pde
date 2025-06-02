Field gameField;

void setup() {
    size(800, 600);
    gameField = new Field();
    gameField.loadFieldImage("field.png");
}

void draw() {
    gameField.update();
    gameField.draw();
}

void keyPressed() {
    gameField.handleKeyPressed();
}
