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
		
		String str= "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, fares, departureDate, departureTime, actualDepartureTime, arrivalDate, arrivalTime, actualArrivalTime, flightStatus FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode JOIN flightstatus USING(flightNum);";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		
		
		
		
		%>
		<h1 style="text-align: center">On-Time/Delayed Flights</h1>
		<table style="border: 1px solid black;">
			<tr>
			<th>Flight #</th>
			<th>Airline</th>
			<th>From Airport</th>
			<th>To Airport</th>
			<th>Fare</th>
			<th>Departure Date</th>
			<th>Departure Time</th>
			<th>Actual Departure Time</th>
			<th>Arrival Date</th>
			<th>Arrival Time</th>
			<th>Actual Arrival Time</th>
			<th>Flight Status</th>
			</tr>
		<%
		
		while(result.next()) {
			//Convert the date we got from the Database to a String so we can compare it to our month string.
			%>
			<tr>
				<td><%=result.getInt("flightNum") %></td>
				<td><%=result.getString("airlineName") %></td>
				<td><%=result.getString("airportFrom") %></td>
				<td><%=result.getString("airportTo") %></td>
				<td>$<%=result.getInt("fares") %></td>
				<td><%=result.getDate("departureDate") %></td>
				<td><%=result.getTime("departureTime") %></td>
				<td><%=result.getTime("actualDepartureTime") %></td>
				<td><%=result.getDate("arrivalDate") %></td>
				<td><%=result.getTime("arrivalTime") %></td>
				<td><%=result.getTime("actualArrivalTime") %></td>
				<td><%=result.getString("flightStatus") %></td>
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