import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

class ReportGenerator extends TimerTask {
    @Override
    public void run() {
        System.out.println("Generating report");
    }
}

class TimerExample {
    public static void main(String[] args) {
        Timer timer = new Timer();
        Calendar date = Calendar.getInstance();
        date.set(Calendar.DAY_OF_WEEK,Calendar.SUNDAY);
        date.set(Calendar.HOUR, 0);
        date.set(Calendar.MINUTE, 0);
        date.set(Calendar.SECOND, 0);
        date.set(Calendar.MILLISECOND, 0);

        // Schedule to run every Sunday in midnight
        //timer.schedule(new ReportGenerator(),date.getTime(),1000 * 60 * 60 * 24 * 7);
        timer.scheduleAtFixedRate(new ReportGenerator(), 1000 * 5, 1000 * 5);
    }
}
