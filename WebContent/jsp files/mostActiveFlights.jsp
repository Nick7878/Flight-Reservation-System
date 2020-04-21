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
		
		String str = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, workingDays, numOfSeats, fares, departureDate, departureTime, arrivalDate, arrivalTime, count(*) AS numOfReservations FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode JOIN reservationflights USING(flightNum) GROUP BY flightNum ORDER BY numOfReservations DESC;";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		
		%>
		<table style="border: 1px solid black;">
			<tr>
			<th>Flight Number</th>
			<th>Airline</th>
			<th>To Airport</th>
			<th>From Airport</th>
			<th>Working Days</th>
			<th>Fare</th>
			<th>Departure Date</th>
			<th>Departure Time</th>
			<th>Arrival Date</th>
			<th>Arrival Time</th>
			<th>Number of Reservations</th>
			</tr>
		<%
		
		while(result.next()) {
			%>
			<tr>
				<td><%=result.getInt("flightNum") %></td>
				<td><%=result.getString("airlineName") %></td>
				<td><%=result.getString("airportTo") %></td>
				<td><%=result.getString("airportFrom") %></td>
				<td><%=result.getInt("workingDays") %></td>
				<td>$<%=result.getInt("fares") %></td>
				<td><%=result.getDate("departureDate") %></td>
				<td><%=result.getTime("departureTime") %></td>
				<td><%=result.getDate("arrivalDate") %></td>
				<td><%=result.getTime("arrivalTime") %></td>
				<td><%=result.getInt("numOfReservations") %></td>
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