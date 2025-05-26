public class Timer {
    private int auto = 15;
    private int tele = 135;
    private int sec = 0;
    private int ellapsedMillis = 1000;
    private int nextTime = 0;
    private int prevTime = 0;
    private int m = millis();

    public Timer(int auto, int tele){
        this.auto = auto;
        this.tele = tele
    }
    
    void draw() {
        if (second()-prevTime>=1){
            prevTime = millis();
            if(auto > 0) auto--;
            if else (tele > 0) tele--;
            else break;
            sec+=1;
        }
    }
}