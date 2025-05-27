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

            }
        }
    }

    public boolean isDownPressed(){
        if (keyPressed){
            if(key == downKey){

            }
        }
    }
    
    public boolean isLeftPressed(){
        if (keyPressed){
            if(key == leftKey){

            }
        }
    }

    public boolean isRightPressed(){
        if (keyPressed){
            if(key == rightKey){

            }
        }
    }

    public boolean isRotateCCWPressed(){
        if (keyPressed){
            if(key == rotateCCWKey){

            }
        }
    }

    public boolean isRotateCWPressed(){
        if (keyPressed){
            if(key == rotateCWKey){

            }
        }
    }
}

