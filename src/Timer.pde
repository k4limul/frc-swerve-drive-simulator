public class Timer {
    private int auto;
    private int teleop;
    private int time;
    private int wait;
    private boolean isAutoFinished;
    private boolean isTeleopFinished;
    private boolean isMatchStarted;

    public Timer() {
        auto = 15;  
        teleop = 135;  
        isAutoFinished = false;
        isTeleopFinished = false;
        isMatchStarted = false;
    }

    public void start() {
        if (!isMatchStarted) {
            time = millis();
            wait = 1000;  
            isMatchStarted = true;
        }
    }

    public void update() {
        if (!isMatchStarted) return;
        int currentTime = (millis() - time) / wait;
        if (!isAutoFinished && currentTime >= auto) {
            isAutoFinished = true;
        }
        if (!isTeleopFinished && currentTime >= (auto + teleop)) {
            isTeleopFinished = true;
        }
    }

    public boolean isFinished() {
        return isAutoFinished && isTeleopFinished;
    }

    public int getTimeLeft() {
        if (!isMatchStarted) return auto + teleop;
        if (isFinished()) return 0;
        int currentTime = (millis() - time) / wait;
        if (currentTime < auto) {
            return auto - currentTime;
        } else if (currentTime < (auto + teleop)) {
            return (auto + teleop) - currentTime;
        }
        return 0;
    }

    public boolean isAutonomous() {
        return isMatchStarted && !isAutoFinished;
    }

    public boolean isTeleop() {
        return isAutoFinished && !isTeleopFinished;
    }
}
