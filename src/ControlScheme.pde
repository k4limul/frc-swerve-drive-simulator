public class ControlScheme{
    private char upKey, downKey, leftKey, rightKey, rotateCCWKey, rotateCWKey;

    public ControlScheme(char upKey, char downKey, char leftKey, char rightKey, char rotateCCWKey, char rotateCWKey){
        this.upKey = upKey;
        this.downKey = downKey;
        this.leftKey = leftKey;
        this.rightKey = rightKey;
        this.rotateCCWKey = rotateCCWKey;
        this.rotateCWKey = rotateCWKey;
    }

    public PVector getTranslationInput() {
        float vx = 0, vy = 0;
        if (keyPressed) {
            if (key == upKey || keyCode == UP) vy += 100;
            if (key == downKey || keyCode == DOWN) vy -= 100;
            if (key == leftKey || keyCode == LEFT) vy -= 100;
            if (key == rightKey || keyCode == RIGHT) vy += 100;
        }
        return new PVector(vx, vy);
    }

    public float getRotationInput() {
        float omega = 0;
        if (keyPressed) {
            if (key == rotateCCWKey) omega -= 90;
            if (key == rotateCWKey) omega += 90;
        }
        return omega;
    }
}

