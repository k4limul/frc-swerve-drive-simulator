public class Timer {
    private int auto;
    private int teleop;
    private int time;
    private int wait;
    private boolean tick = false;
    private boolean isAutoFinished;
    private boolean isTeleopFinished;

    public Timer(){
        auto = 15;
        teleop = 135;
    }

    void setup(){
        int time = millis();
        int wait = 1000;
    }

    void draw() {
        if(millis() - time >= wait) time = millis();
        if((auto - time / wait) <= 0) isAutoFinished = true;
        if(((teleop + auto) - time / wait) <= 0) isTeleopFinished = true;
    }

    public void isFinished() {
        return isAutoFinished && isTeleopFinished;
    }

    public int getTimeLeft() {
        if (isFinished()) return 0;
        else if (teleop > 0) return teleop;
        else if (auto > 0) return auto + teleop;
    }
}
