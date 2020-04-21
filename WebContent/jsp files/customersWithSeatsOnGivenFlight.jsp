<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, java.sql.Date, java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat, java.text.DateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file = "../html/genericPage.html" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>title</title>
<link rel = "stylesheet" href = "../css/genericCSS.css">
</head>
<body>
	<%
	try{
		
		String flightNum = request.getParameter("flightNumber");
		
		//Create a connection string
		//name the schema cs336project otherwise this url will not work!
		String url = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
		//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
		Class.forName("com.mysql.jdbc.Driver");

		//Create a connection to your DB
		//the second argument is the username, and the third argument is the password. Password will be different for everyone
		Connection con = DriverManager.getConnection(url, "root", "gameboy*1");
		
		//Create a SQL statement
		Statement stmt = con.createStatement();
		//Get the combobox from the HelloWorld.jsp
		
		String str = "SELECT accountNum, email, firstName, lastName, address, city, state, zipCode, telephone FROM customer JOIN accounts USING(accountNum) JOIN reservations USING(accountNum) JOIN reservationflights USING(reservationCode) JOIN flight USING(flightNum) WHERE flightNum = '" + flightNum + "' GROUP BY accountNum;";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		
		%>
		<table style="border: 1px solid black;">
			<tr>
			<th>Account Number</th>
			<th>Email</th>
			<th>First Name</th>
			<th>Last Name</th>
			<th>Address</th>
			<th>City</th>
			<th>State</th>
			<th>ZipCode</th>
			<th>Phone Number</th>
			</tr>
		<%
		
		while(result.next()) {
			%>
			<tr>
				<td><%=result.getInt("accountNum") %></td>
				<td><%=result.getString("email") %></td>
				<td><%=result.getString("firstName") %></td>
				<td><%=result.getString("lastName") %></td>
				<td><%=result.getString("address") %></td>
				<td><%=result.getString("city") %></td>
				<td><%=result.getString("state") %></td>
				<td><%=result.getString("zipCode") %></td>
				<td><%=result.getString("telephone") %></td>
			</tr>
			<%
		}
		%>
		</table>
		<% 
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