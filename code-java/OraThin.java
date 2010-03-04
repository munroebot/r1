import java.io.*;
import java.sql.*;

public class OraThin {
  public static void main(String[] args) {
    try {
      Connection con=null;
      Class.forName("oracle.jdbc.OracleDriver");
      con=DriverManager.getConnection("jdbc:oracle:thin:localhost:1521:XE","brian","password");
      Statement s=con.createStatement();
      s.execute("select * from hello");
      s.close();
      con.close();
   } catch(Exception e){e.printStackTrace();}
 }
}