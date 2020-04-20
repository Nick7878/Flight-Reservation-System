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
		//Get the combobox from the HelloWorld.jsp
		System.out.println(request.getParameter("value"));
		
		//current time for today
		
		String str= "SELECT flightNum, airline, airportTo, airportFrom, numOfSeats, availableSeats, fares, departureDate, departureTime,arrivalDate, arrivalTime FROM flight WHERE departureDate >= (SELECT CURDATE()) OR (departureDate <=(SELECT CURDATE()) AND arrivalDate >(SELECT CURDATE())) AND departureDate IN (SELECT departureDate FROM flight WHERE departureTime <= (SELECT CURRENT_TIME()) AND arrivalTime <= (SELECT CURRENT_TIME()) ORDER BY flightNum)AND arrivalDate IN (SELECT arrivalDate FROM flight WHERE departureTime <= (SELECT CURRENT_TIME()) AND arrivalTime <= (SELECT CURRENT_TIME()) ORDER BY flightNum)ORDER BY flightNum;";
		//Run the query against the database.
		ResultSet onTime = stmt.executeQuery(str);
		
		
		
		
		%>
		<h1>ONTIME</h1>
		<table style="border: 1px solid black;">
			<tr>
			<th>Flight Number</th>
			<th>Airline</th>
			<th>To Airport</th>
			<th>From Airport</th>
			<th># of Seats</th>
			<th># of Available Seats</th>
			<th>Fare</th>
			<th>Departure Date</th>
			<th>Departure Time</th>
			<th>Arrival Date</th>
			<th>Arrival Time</th>
			</tr>
		<%
		
		while(onTime.next()) {
			//Convert the date we got from the Database to a String so we can compare it to our month string.
			%>
			<tr>
				<td><%=onTime.getInt("flightNum") %></td>
				<td><%=onTime.getString("airline") %></td>
				<td><%=onTime.getString("airportTo") %></td>
				<td><%=onTime.getString("airportFrom") %></td>
				<td><%=onTime.getInt("numOfSeats") %></td>
				<td><%=onTime.getInt("availableSeats") %>
				<td><%=onTime.getInt("fares") %></td>
				<td><%=onTime.getDate("departureDate") %></td>
				<td><%=onTime.getTime("departureTime") %></td>
				<td><%=onTime.getDate("arrivalDate") %></td>
				<td><%=onTime.getTime("arrivalTime") %></td>
			</tr>
			<%
			
		}
		String str2= "SELECT flightNum, airline, airportTo, airportFrom, numOfSeats, availableSeats, fares, departureDate, departureTime,arrivalDate, arrivalTime FROM flight WHERE departureDate <= (SELECT CURDATE()) AND arrivalDate < (SELECT CURDATE())ORDER BY flightnum;";
		//Run the query against the database.
		ResultSet delayed  = stmt.executeQuery(str2);
		%>
		</table>
		<% 
		%>
		<h1>DELAYED</h1>
		<table style="border: 1px solid black;">
			<tr>
			<th>Flight Number</th>
			<th>Airline</th>
			<th>To Airport</th>
			<th>From Airport</th>
			<th># of Seats</th>
			<th># of Available Seats</th>
			<th>Fare</th>
			<th>Departure Date</th>
			<th>Departure Time</th>
			<th>Arrival Date</th>
			<th>Arrival Time</th>
			</tr>
		<%
		
		while(delayed.next()) {
			//Convert the date we got from the Database to a String so we can compare it to our month string.
			%>
			
			<tr>
				<td><%=delayed.getInt("flightNum") %></td>
				<td><%=delayed.getString("airline") %></td>
				<td><%=delayed.getString("airportTo") %></td>
				<td><%=delayed.getString("airportFrom") %></td>
				<td><%=delayed.getInt("numOfSeats") %></td>
				<td><%=delayed.getInt("availableSeats") %>
				<td><%=delayed.getInt("fares") %></td>
				<td><%=delayed.getDate("departureDate") %></td>
				<td><%=delayed.getTime("departureTime") %></td>
				<td><%=delayed.getDate("arrivalDate") %></td>
				<td><%=delayed.getTime("arrivalTime") %></td>
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