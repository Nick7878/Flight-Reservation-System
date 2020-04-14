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
<head>

</head>
<p><br></p>
<form action =" " method = "post">
	<div class = "form-group">
	<label> Last Name </label>
	<input type = "text" class = "form-control" name = "ln" placeholder = 'Last Name'>
	</div>
	
	<div class = "form-group">
	<label> First Name</label>
	<input type = "text" class = "form-control" name = "fn" placeholder = 'First Name'>
	</div>
	
	<div class = "form-group">
	<label> Address </label>
	<input type = "text" class = "form-control" name = "adr" placeholder = 'Address'>
	</div>
	
	<div class = "form-group">
	<label> City</label>
	<input type = "text" class = "form-control" name = "ci" placeholder = 'City'>
	</div>
	
	<div class = "form-group">
	<label> State </label>
	<input type = "text" class = "form-control" name = "st" placeholder = 'State'>
	</div>
	
	<div class = "form-group">
	<label> Zipcode</label>
	<input type = "text" class = "form-control" name = "zip" placeholder = 'Zipcode'>
	</div>
	
	<div class = "form-group">
	<label> Telephone</label>
	<input type = "text" class = "form-control" name = "tel" placeholder = 'Telephone'>
	</div>
	
	<div class = "form-group">
	<label> Credit Card Number</label>
	<input type = "text" class = "form-control" name = "ccn" placeholder = 'Credit Card'>
	</div>
	<button type = "submit" class = "btn"> Submit</button>
	<a href = "managerTest.jsp" class = "btn-def"> Back </a>
	</form>
	

</html>
<%
String a = request.getParameter("ln");
String b = request.getParameter("fn");
String c = request.getParameter("adr");
String d = request.getParameter("ci");
String e = request.getParameter("st");
String f = request.getParameter("zip");
String g = request.getParameter("tel");
String h = request.getParameter("ccn");

String host = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
Connection conn = null;
PreparedStatement stat = null;
PreparedStatement statA = null;
Class.forName("com.mysql.jdbc.Driver");
if(a!=null && b!=null && c!=null && d!=null && e!=null&& f!=null && g!=null && h !=null)
{
	conn = DriverManager.getConnection(host, "root", "gameboy*1");
	
	String insertToAcct = "INSERT INTO accounts1 (creationDate, accountPassword, email, preferences, isManager)"
			+ " VALUES (?, ?, ?, '', ?)";

	
	statA.executeUpdate();
	statA.close();
	
	String data = "Insert INTO customers1 (lastName, firstName, address, city, state, zipCode, telephone, creditCardNum)"
			+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
	stat = conn.prepareStatement(data);
	stat.setString(1,a);
	stat.setString(2,b);
	stat.setString(3,c);
	stat.setString(4,d);
	stat.setString(5,e);
	stat.setString(6,f);
	stat.setString(7,g);
	stat.setString(8,h);
	response.sendRedirect("managerTest.jsp");
	stat.executeUpdate();
	conn.close(); 
%>
	<script> 
    alert("Congratulations! Your new account is created!");
	window.location.href = "managerTest.jsp";
	</script>
<%
}
%>
