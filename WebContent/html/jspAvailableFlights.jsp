<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, java.sql.Date, java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat, java.text.DateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file = "reservationResults.html" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>title</title>
</head>
<body>
	<%
	Cookie cookie = null;
    Cookie[] cookies = null;

    // Get an array of Cookies associated with the this domain
    cookies = request.getCookies();

    //Gets AccountNum
    cookie = cookies[0];
    int accountNum = Integer.parseInt(cookie.getValue());
	
	try{
		System.out.println("Round Trip: " + request.getParameter("roundTrip"));
		session.setAttribute("numberOfPassengers", request.getParameter("numOfPassengers"));
		if(request.getParameter("roundTrip") == null) {
			session.setAttribute("round-trip", 1);
		} else {
			session.setAttribute("round-trip", request.getParameter("roundTrip"));	
		}
		session.setAttribute("fromAirport", request.getParameter("fromAirport"));
		session.setAttribute("toAirport", request.getParameter("toAirport"));
		
		String airportTo = request.getParameter("toAirport");
		String airportFrom = request.getParameter("fromAirport");
		String departureDate = request.getParameter("departureDate");
		String returnDate = request.getParameter("returnDate");
		String roundTrip = request.getParameter("roundTrip");
		String numOfPassengers = request.getParameter("numOfPassengers");
		
		
		//Create a connection string
		//name the schema cs336project otherwise this url will not work!
		String url = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
		//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
		Class.forName("com.mysql.jdbc.Driver");

		//Create a connection to your DB
		//the second argument is the username, and the third argument is the password. Password will be different for everyone
		Connection con = DriverManager.getConnection(url, "root", "gameboy*1");
		
		//Create a SQL statement
		Statement flightsAvailableOnSpecificDayOneWayStatement = con.createStatement();
		Statement flightsAvailableInCertainDateRangeOneWayStatement = con.createStatement();
		
		//gets flight on specific day
		String flightAvailableOnSpecificDayOneWayQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE (departureDate = '" + departureDate + "') AND (flight.airportTo = '" + airportTo + "' AND flight.airportFrom = '" + airportFrom + "') AND (NOT ((availableSeats - " + numOfPassengers + ") < 0));";
		
		//Gets flights in a certain date range
		String flightAvailableOnCertainDateRangeOneWayQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE ((departureDate BETWEEN '2020-04-08' AND '2020-04-11') OR (departureDate BETWEEN '2020-04-11' AND '2020-04-14')) AND (flight.airportTo = 'SAN' AND flight.airportFrom = 'EWR') AND (NOT ((availableSeats - 2) < 0));";
		
		//Gets last name for current account logged in
		String lastNameQuery = "SELECT lastName FROM customer WHERE accountNum = '" + accountNum + "';";
		//Run the query against the database.
		ResultSet result = flightsAvailableOnSpecificDayOneWayStatement.executeQuery(flightAvailableOnSpecificDayOneWayQuery);
		%>
		<form action="jspReserveFlightOneWay.jsp" method="post">
	    <div class="depart">
	            <table>
	                <tr>
	                	<th></th>
						<th>Flight Number</th>
						<th>Airline</th>
						<th>To Airport</th>
						<th>From Airport</th>
						<th>Available Seats</th>
						<th>Fare</th>
						<th>Departure Date</th>
						<th>Departure Time</th>
						<th>Arrival Date</th>
						<th>Arrival Time</th>
					</tr>

	                <%
		
					while(result.next()) {
						%>
						<tr>
							<td>
			                    <div class="radio">
			                         <label><input type="radio" name="one-way" value=<%=result.getInt("flightNum") %>></label>
			                    </div>
			               	</td>
							<td><%=result.getInt("flightNum") %></td>
							<td><%=result.getString("airlineName") %></td>
							<td><%=result.getString("airportTo") %></td>
							<td><%=result.getString("airportFrom") %></td>
							<td><%=result.getInt("availableSeats") %></td>
							<td>$<%=result.getInt("fares") %></td>
							<td><%=result.getDate("departureDate") %></td>
							<td><%=result.getTime("departureTime") %></td>
							<td><%=result.getDate("arrivalDate") %></td>
							<td><%=result.getTime("arrivalTime") %></td>
						</tr>
						<%
					}
		%>
		</table>
		<input type="submit" name="reserve">
		</div>
		</form>
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