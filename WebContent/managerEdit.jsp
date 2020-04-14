 <%@page import ="java.sql.DriverManager"%>
 <%@page import ="java.sql.ResultSet"%>
 <%@page import ="java.sql.Statement"%>
 <%@page import ="java.sql.Connection"%> 
 <%@page import = "java.sql.PreparedStatement" %>
 <%@page contentType = "text/html" pageEncoding = "UTF-8"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.Date,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head> </head>
<p><br></p>
<%
String host = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
Statement stat = null;
ResultSet res = null;
PreparedStatement stmt = null;
Connection conn = null;
Class.forName("com.mysql.jdbc.Driver").newInstance();
conn = DriverManager.getConnection(host, "root", "gameboy*1");


%>
<form action =" " method = "post">
	<%
	stat = conn.createStatement();
	String u = request.getParameter("u");
	int num = Integer.parseInt(u);
	String data = "SELECT * FROM customer WHERE accountNum = " + num +" ";
	res = stat.executeQuery(data);
	while(res.next()){
	%>
	<input type = "hidden" name = "id" value = <%=res.getString("accountNum") %> />
	<div class = "form-group">
	<label> Last Name </label>
	<input type = "text" class = "form-control" name = "ln" value = <%=res.getString("lastName") %> />
	</div>
	
	<div class = "form-group">
	<label> First Name</label>
	<input type = "text" class = "form-control" name = "fn" value = <%=res.getString("firstName") %> />
	</div>
	
	<div class = "form-group">
	<label> Address </label>
	<input type = "text" class = "form-control" name = "adr" value = <%=res.getString("address") %> />
	</div>
	
	<div class = "form-group">
	<label> City</label>
	<input type = "text" class = "form-control" name = "ci" value = <%=res.getString("city") %> />
	</div>
	
	<div class = "form-group">
	<label> State </label>
	<input type = "text" class = "form-control" name = "st" value = <%=res.getString("state") %> />
	</div>
	
	<div class = "form-group">
	<label> Zipcode</label>
	<input type = "text" class = "form-control" name = "zip" value = <%=res.getString("zipCode") %> />
	</div>
	
	<div class = "form-group">
	<label> Telephone</label>
	<input type = "text" class = "form-control" name = "tel" value = <%=res.getString("telephone") %> />
	</div>
	
	<div class = "form-group">
	<label> Credit Card Number</label>
	<input type = "text" class = "form-control" name = "ccn" value = <%=res.getString("creditCardNum") %> />
	</div>
	<%
	}
	%>
	<button type = "submit" class = "btnwa"> Update</button>
	<a href = "managerTest.jsp" class = "btn-def"> Back </a>
	</form>
</html>
<%
String z = request.getParameter("id");
String a = request.getParameter("ln");
String b = request.getParameter("fn");
String c = request.getParameter("adr");
String d = request.getParameter("ci");
String e = request.getParameter("st");
String f = request.getParameter("zip");
String g = request.getParameter("tel");
String h = request.getParameter("ccn");

if(a!=null && b!=null && c!=null && d!=null && e!=null&& f!=null && g!=null && h !=null){
	String query = "UPDATE customer SET lastName = ?, firstName = ?, address = ?, city = ?, state = ?, zipCode = ?, telephone = ?, creditCardNum = ? WHERE accountNum = " + z + " ";
	stmt = conn.prepareStatement(query);
	stmt.setString(1,a);
	stmt.setString(2,b);
	stmt.setString(3,c);
	stmt.setString(4,d);
	stmt.setString(5,e);
	stmt.setString(6,f);
	stmt.setString(7,g);
	stmt.setString(8,h);
	stmt.executeUpdate();
	response.sendRedirect("managerTest.jsp");
}


%>
