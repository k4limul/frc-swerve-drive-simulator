public class ControlScheme{
    private char upKey, downKey, leftKey, rightKey, rotateCCWKey, rotateCWKey, shootKey, climbKey;
    // Track boolean states of every key (256 possible char-key pairs)
    private boolean[] keys = new boolean[256];

    public ControlScheme(char upKey, char downKey, char leftKey, char rightKey, char rotateCCWKey, char rotateCWKey, char shootKey, char climbKey){
        this.upKey = upKey;
        this.downKey = downKey;
        this.leftKey = leftKey;
        this.rightKey = rightKey;
        this.rotateCCWKey = rotateCCWKey;
        this.rotateCWKey = rotateCWKey;
        this.shootKey = shootKey;
        this.climbKey = climbKey;
    }
    
    // Called in main sketch
    public void keyPressed(char key, int keyCode) {
        // Set key value in array to true
        if (key >= 0 && key < keys.length) {
            keys[key] = true;
        }
        if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
            if (keyCode < keys.length) {
                keys[keyCode] = true;
            }
        }
    }
    
    // Called in main sketch
    public void keyReleased(char key, int keyCode) {
        // Set key value in array to false
        if (key >= 0 && key < keys.length) {
            keys[key] = false;
        }
        if (keyCode == UP || keyCode == DOWN || keyCode == LEFT || keyCode == RIGHT) {
            if (keyCode < keys.length) {
                keys[keyCode] = false;
            }
        }
    }

    // Helper method to check if a key is currently pressed
    private boolean isKeyPressed(int keyToCheck) {
        if (keyToCheck >= 0 && keyToCheck < keys.length) {
            return keys[keyToCheck];
        }
        return false;
    }

    public PVector getTranslationInput(int step) {
        float vx = 0, vy = 0;
        
        if (isKeyPressed(upKey) || isKeyPressed(UP)) vy -= step;
        if (isKeyPressed(downKey) || isKeyPressed(DOWN)) vy += step;
        if (isKeyPressed(leftKey) || isKeyPressed(LEFT)) vx -= step;
        if (isKeyPressed(rightKey) || isKeyPressed(RIGHT)) vx += step;
        
        return new PVector(vx, vy);
    }

    public float getRotationInput(int step) {
        float omega = 0;
        
        if (isKeyPressed(rotateCCWKey)) omega -= step;
        if (isKeyPressed(rotateCWKey)) omega += step;
        
        return omega;
    }

    public boolean isShootKeyPressed() {
        return isKeyPressed(shootKey);
    }

    public boolean isClimbKeyPressed() {
        return isKeyPressed(climbKey);
    }
}