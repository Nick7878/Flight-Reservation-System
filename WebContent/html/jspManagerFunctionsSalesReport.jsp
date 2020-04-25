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
<title>Sales Report</title>
<link rel = "stylesheet" href = "../css/genericCSS.css">
</head>
<body>
	<%
	try{
		
		String month = request.getParameter("value");
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
		
		String str = "SELECT travelDate, reservationCode, firstName, lastName, passengers, reservationType, reservationCreationDate, SUM(totalFare) AS totalRevenue FROM reservations JOIN customer USING(accountNum) GROUP BY(reservationCode) HAVING MONTH(travelDate) = '" + month + "';";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		
		%>
		<table style="border: 1px solid black;">
			<tr>
			<th>Travel Date</th>
			<th>Reservation Code</th>
			<th>First Name</th>
			<th>Last Name</th>
			<th># of Passengers</th>
			<th>Reservation Type</th>
			<th>Reservation Creation Date</th>
			<th>Total Revenue</th>
			</tr>
		<%
		
		int totalRevenue = 0;
		while(result.next()) {
			String reservationType = "";
			if(result.getInt("reservationType") == 1) {
				reservationType = "One-Way";
			} else if(result.getInt("reservationType") == 2) {
				reservationType = "Round-Trip";
			} else {
				reservationType = "Multi-Leg";
			}
			%>
			<tr>
				<td><%=result.getDate("travelDate") %></td>
				<td><%=result.getString("reservationCode") %></td>
				<td><%=result.getString("firstName") %></td>
				<td><%=result.getString("lastName") %></td>
				<td><%=result.getInt("passengers") %></td>
				<td><%=reservationType%></td>
				<td><%=result.getDate("reservationCreationDate") %></td>
				<td>$<%=result.getDouble("totalRevenue") %></td>
			</tr>
			<%
			totalRevenue += result.getDouble("totalRevenue");
		}
		%>
		</table>
		<h3>Total Revenue for the Month: $<%=totalRevenue %></h3>
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