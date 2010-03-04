<jsp:directive.page import="javax.naming.*" />
<jsp:directive.page import="java.sql.*" />
<jsp:directive.page import="javax.sql.*" />

<html>
<body>

<h1>hello, world</h1>

<%

InitialContext ic = new InitialContext();
DataSource ds = (DataSource) ic.lookup("java:comp/env/jdbc/XEDB");
Connection conn = ds.getConnection();

Statement s = conn.createStatement();
ResultSet rs = s.executeQuery("select * from hello");

while (rs.next()) {
    out.println(rs.getInt(1) + "<br/>");
}

s.close();
conn.close();

%>

</body>
</html>



