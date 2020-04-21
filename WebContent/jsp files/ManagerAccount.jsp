<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.Date,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/login.css">

<title>Creating new user ...</title>
</head>
<body>
	<%
	
	//Get parameters from the HTML form at the login.jsp
	String custAcct = request.getParameter("custAcct");
	
	
	try {

		//Create a connection string
		String url = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
		//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
		Class.forName("com.mysql.jdbc.Driver");

		//Create a connection to the DB
		Connection con = DriverManager.getConnection(url, "root", "gameboy*1");

		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		
	} catch (Exception ex) {
		ex.printStackTrace();
		%> 
		<!-- if error, show the alert and go back to login page --> 
		<script> 
		    alert("Sorry, something went wrong on our server, failed to create your account");
		    window.location.href = "../html/createAccount.html";
		</script>
		<%
		return;
	}
%>
</body>
</html>