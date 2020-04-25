<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, java.sql.Date, java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat, java.text.DateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file = "genericPage.html" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="../css/myReservationsAndFlightHistoryStyle.css" />
<title>title</title>
<link rel = "stylesheet" href = "../css/genericCSS.css">
</head>
<body>

	<%

	try{
		String accNum= request.getParameter("accNum");
		String sqlLastName = request.getParameter("lastName");
		String sqlFirstName = request.getParameter("firstName");
		String sqlAddress = request.getParameter("address");
		String sqlCity = request.getParameter("city");
		String sqlState = request.getParameter("state");
		String sqlZip = request.getParameter("zip");
		String sqlTelephone = request.getParameter("telephone");
		String sqlCreditCard = request.getParameter("creditCard");
		
		
		//Create a connection string
		//name the schema cs336project otherwise this url will not work!
		String url = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
		//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
		Class.forName("com.mysql.jdbc.Driver");

		//Create a connection to your DB
		//the second argument is the username, and the third argument is the password. Password will be different for everyone
		Connection con = DriverManager.getConnection(url, "root", "gameboy*1");
		
		//Create a SQL statement
		PreparedStatement stmt;
		//Get the combobox from the HelloWorld.jsp
		
		if(sqlLastName!=null && sqlFirstName!=null && sqlAddress!=null && sqlCity!=null && sqlState!=null&& sqlZip!=null && sqlTelephone!=null && sqlCreditCard !=null){
			String query = "UPDATE customer SET lastName = ?, firstName = ?, address = ?, city = ?, state = ?, zipCode = ?, telephone = ?, creditCardNum = ? WHERE accountNum = " + accNum + " ";
			stmt = con.prepareStatement(query);
			stmt.setString(1,sqlLastName);
			stmt.setString(2,sqlFirstName);
			stmt.setString(3,sqlAddress);
			stmt.setString(4,sqlCity);
			stmt.setString(5,sqlState);
			stmt.setString(6,sqlZip);
			stmt.setString(7,sqlTelephone);
			stmt.setString(8,sqlCreditCard);
			stmt.executeUpdate();
			
			%>
			<script>
				alert("Update Successful!");
		    	window.location.href = "jspManagerTest.jsp";
			</script>
			<%
		}
		
	} catch(Exception e) {
		e.printStackTrace();
		%>
		<script>
			alert("Sorry, unexcepted error happens.");
	    	//window.location.href = "login.html";
		</script>
		<%	
	}
	%>
</body>
</html>