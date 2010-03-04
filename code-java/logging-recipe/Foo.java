import org.apache.log4j.*;

public class Foo {
  private static final Logger logger = Logger.getLogger("Foo.class");
  public static void main(String [] args) {
    logger.debug("Start of main()");
    logger.info("Just testing a log message with priority set to INFO");
    logger.warn("Just testing a log message with priority set to WARN");
    logger.error("Just testing a log message with priority set to ERROR");
    logger.fatal("Just testing a log message with priority set to FATAL");
  }
}

