public class ControlScheme{
    private char upKey;
    private char downKey;
    private char leftKey;
    private char rightKey;
    private char rotateCCWKey;
    private char rotateCWKey;

    public ControlScheme(){
        this.upKey = '';
        this.downKey = '';
        this.leftKey = '';
        this.rightKey = '';
        this.rotateCCWKey = '';
        this.rotateCWKey = '';
    }
    public ControlScheme(char upKey, char downKey, char leftKey, char rightKey, char rotateCCWKey, char rotateCWKey){
        this.upKey = upKey;
        this.downKey = downKey;
        this.leftKey = leftKey;
        this.rightKey = rightKey;
        this.rotateCCWKey = rotateCCWKey;
        this.rotateCWKey = rotateCWKey;
    }
    
    public boolean isUpPressed(){
        if (keyPressed){
            if(key == upKey){
                return true;
            }
        }
    }

    public boolean isDownPressed(){
        if (keyPressed){
            if(key == downKey){
                return true;
            }
        }
    }
    
    public boolean isLeftPressed(){
        if (keyPressed){
            if(key == leftKey){
                return true;
            }
        }
    }

    public boolean isRightPressed(){
        if (keyPressed){
            if(key == rightKey){
                return true;
            }
        }
    }

    public boolean isRotateCCWPressed(){
        if (keyPressed){
            if(key == rotateCCWKey){
                return true;
            }
        }
    }

    public boolean isRotateCWPressed(){
        if (keyPressed){
            if(key == rotateCWKey){
                return true;
            }
        }
    }
}

