<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, java.sql.Date, java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat, java.text.DateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file = "bestSellingFlights.html" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>title</title>
</head>
		<h2 style="text-align: center;">Hottest Flights Right Now!</h2>

        <table style = "width: 100%;">
        <thead>
            <tr>
			<th>Flight Number</th>
			<th>Airline</th>
			<th>Origin</th>
			<th>Destination </th>
			<th>Fare</th>
			<th>Departure Date</th>
			<th>Departure Time</th>
			<th>Arrival Date</th>
			<th>Arrival Time</th>
			<th>Seats Available </th>
			<th>Seats Taken </th>
			<th>Number Of Seats </th>
			<th> % Seats Taken </th>
            </tr>
            </thead>
            <tbody>
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
		
		//Run the query against the database.
		String str = " SELECT flightNum, airlineName, a1.airportName AS airportFrom, a2.airportName AS airportTo, fares, departureDate, departureTime, arrivalDate, arrivalTime, availableSeats, (numOfSeats - availableSeats) AS seatsTaken, numOfSeats, (((numOfSeats - availableSeats) / numOfSeats) * 100) AS percentOfSeatsTaken ";
				str += "FROM flight ";
				str += "JOIN airline ON flight.airline = airline.airlineCode ";
				str += "JOIN airport a1 ON flight.airportTo = a1.airportCode ";
				str += "JOIN airport a2 ON flight.airportFrom = a2.airportCode ";
				str += "ORDER BY (((numOfSeats - availableSeats) / numOfSeats) * 100) DESC ";
				str += "LIMIT 3;";
				System.out.println(str);
		ResultSet result = stmt.executeQuery(str);
		
		%>

		<%
		
		while(result.next()) {
			%>
			<tr>
				<td><%=result.getInt("flightNum") %></td>
				<td><%=result.getString("airlineName") %></td>
				<td><%=result.getString("airportFrom") %></td>
				<td><%=result.getString("airportTo") %></td>
				<td>$<%=result.getInt("fares") %></td>
				<td><%=result.getDate("departureDate") %></td>
				<td><%=result.getTime("departureTime") %></td>
				<td><%=result.getDate("arrivalDate") %></td>
				<td><%=result.getTime("arrivalTime") %></td>
				<td><%=result.getInt("availableSeats") %></td>
				<td><%=result.getInt("seatsTaken") %></td>
				<td><%=result.getInt("numOfSeats") %></td>
				<td><%=result.getDouble("percentOfSeatsTaken") %></td>
				
				<!-- Add a total revenue field from every flight -->
			</tr>
			
			<%
		}
		%>
		</tbody>
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

</html>