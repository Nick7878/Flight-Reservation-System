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
<title>title</title>
<link rel = "stylesheet" href = "../css/genericCSS.css">
</head>
<body>
	<%
	try{
		String flightNum = request.getParameter("flightNumber");
		String firstName = request.getParameter("firstName");
		String lastName = request.getParameter("lastName");
		
		
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
		System.out.println(request.getParameter("value"));
		
		String str = "SELECT reservationNum, totalFare, travelDate, legs, bookFee, passengers, flightNum, accountNum FROM reservation JOIN customer USING(accountNum) JOIN flight USING(flightNum) WHERE (firstName = '" + firstName + "' AND lastName = '" + lastName + "') OR (flightNum = '" + flightNum + "');";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		
		%>
		<table style="border: 1px solid black;">
			<tr>
			<th>Reservation #</th>
			<th>Total Cost</th>
			<th>Travel Date</th>
			<th>Layover's</th>
			<th>Booking Fee</th>
			<th>Passengers</th>
			<th>Flight #</th>
			<th>Account #</th>
			</tr>
		<%
		
		while(result.next()) {
			//Convert the date we got from the Database to a String so we can compare it to our month string.
			%>
			<tr>
				<td><%=result.getInt("reservationNum") %></td>
				<td><%=result.getDouble("totalFare") %></td>
				<td><%=result.getDate("travelDate") %></td>
				<td><%=result.getInt("legs") %></td>
				<td><%=result.getInt("totalFare") %></td>
				<td><%=result.getDouble("bookFee") %></td>
				<td><%=result.getInt("passengers") %></td>
				<td><%=result.getInt("flightNum") %></td>
				<td><%=result.getInt("accountNum") %></td>
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