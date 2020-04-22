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
		Statement oneWayFlightStatement = con.createStatement();
		Statement roundTripFlightStatement = con.createStatement();
		
		//gets flight on specific day
		String flightAvailableOnSpecificDayOneWayQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE (departureDate = '" + departureDate + "') AND (flight.airportTo = '" + airportTo + "' AND flight.airportFrom = '" + airportFrom + "') AND (NOT ((availableSeats - " + numOfPassengers + ") < 0));";
		
		//Gets flights in a certain date range
		String flightAvailableOnCertainDateRangeOneWayQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE ((departureDate BETWEEN DAY('" + departureDate + "') - 3 AND '" + departureDate + "') OR (departureDate BETWEEN '" + departureDate + "' AND DAY('" + departureDate + "') + 3)) AND (flight.airportTo = '" + airportTo + "' AND flight.airportFrom = '" + airportFrom + "') AND (NOT ((availableSeats - '" + numOfPassengers + "') < 0));";
		
		//Gets flight for a round trip flight
		String returningFlightQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE (departureDate = '" + returnDate + "') AND (flight.airportTo = '" + airportFrom + "' AND flight.airportFrom = '" + airportTo + "') AND (NOT ((availableSeats - " + numOfPassengers + ") < 0));";
				
		System.out.println(flightAvailableOnCertainDateRangeOneWayQuery);
				
		
		
		//Gets last name for current account logged in
		String lastNameQuery = "SELECT lastName FROM customer WHERE accountNum = '" + accountNum + "';";
		//Run the query against the database.
		%>
		<%
			if(session.getAttribute("round-trip") == Integer.valueOf(1)) {
				ResultSet oneWayResult = oneWayFlightStatement.executeQuery(flightAvailableOnSpecificDayOneWayQuery);
				if(!oneWayResult.next()) {
					oneWayResult = oneWayFlightStatement.executeQuery(flightAvailableOnCertainDateRangeOneWayQuery);
					if(!oneWayResult.next()) {
						%>
						<script>
							alert("No results for flight on specific date or date range. Returning to homepage");
					    	window.location.href = "homepage.html";
						</script>
						<%	
					}
					%>
					<script>
						alert("No results for flight on specific date. Showing flights within 3 days of specified departure date");
					</script>
					<%
				}
				oneWayResult.previous();
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
							while(oneWayResult.next()) {
								%>
								<tr>
									<td>
					                    <div class="radio">
					                         <label><input type="radio" name="one-way" value=<%=oneWayResult.getInt("flightNum") %>></label>
					                    </div>
					               	</td>
									<td><%=oneWayResult.getInt("flightNum") %></td>
									<td><%=oneWayResult.getString("airlineName") %></td>
									<td><%=oneWayResult.getString("airportTo") %></td>
									<td><%=oneWayResult.getString("airportFrom") %></td>
									<td><%=oneWayResult.getInt("availableSeats") %></td>
									<td>$<%=oneWayResult.getInt("fares") %></td>
									<td><%=oneWayResult.getDate("departureDate") %></td>
									<td><%=oneWayResult.getTime("departureTime") %></td>
									<td><%=oneWayResult.getDate("arrivalDate") %></td>
									<td><%=oneWayResult.getTime("arrivalTime") %></td>
								</tr>
								<%
							}
				%>
						</table>
						
				<input type="submit" name="reserve">
				</div>
				</form>
				<%
		 
			} else {	//End of round trip checker IF
				ResultSet oneWaySpecificDayResult = oneWayFlightStatement.executeQuery(flightAvailableOnSpecificDayOneWayQuery);
			%>
			<form action="jspReserveFlightRoundTrip.jsp" method="post">
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

						while(oneWaySpecificDayResult.next()) {
							%>
							<tr>
								<td>
				                    <div class="radio">
				                         <label><input type="radio" name="one-way" value=<%=oneWaySpecificDayResult.getInt("flightNum") %>></label>
				                    </div>
				               	</td>
								<td><%=oneWaySpecificDayResult.getInt("flightNum") %></td>
								<td><%=oneWaySpecificDayResult.getString("airlineName") %></td>
								<td><%=oneWaySpecificDayResult.getString("airportTo") %></td>
								<td><%=oneWaySpecificDayResult.getString("airportFrom") %></td>
								<td><%=oneWaySpecificDayResult.getInt("availableSeats") %></td>
								<td>$<%=oneWaySpecificDayResult.getInt("fares") %></td>
								<td><%=oneWaySpecificDayResult.getDate("departureDate") %></td>
								<td><%=oneWaySpecificDayResult.getTime("departureTime") %></td>
								<td><%=oneWaySpecificDayResult.getDate("arrivalDate") %></td>
								<td><%=oneWaySpecificDayResult.getTime("arrivalTime") %></td>
							</tr>
							<%
						}
			%>
					</table>
					
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
					ResultSet roundTripSpecificDayResult = roundTripFlightStatement.executeQuery(returningFlightQuery);
						while(roundTripSpecificDayResult.next()) {
					%>
							<tr>
								<td>
				                    <div class="radio">
				                         <label><input type="radio" name="round-trip" value=<%=roundTripSpecificDayResult.getInt("flightNum") %>></label>
				                    </div>
				               	</td>
								<td><%=roundTripSpecificDayResult.getInt("flightNum") %></td>
								<td><%=roundTripSpecificDayResult.getString("airlineName") %></td>
								<td><%=roundTripSpecificDayResult.getString("airportTo") %></td>
								<td><%=roundTripSpecificDayResult.getString("airportFrom") %></td>
								<td><%=roundTripSpecificDayResult.getInt("availableSeats") %></td>
								<td>$<%=roundTripSpecificDayResult.getInt("fares") %></td>
								<td><%=roundTripSpecificDayResult.getDate("departureDate") %></td>
								<td><%=roundTripSpecificDayResult.getTime("departureTime") %></td>
								<td><%=roundTripSpecificDayResult.getDate("arrivalDate") %></td>
								<td><%=roundTripSpecificDayResult.getTime("arrivalTime") %></td>
							</tr>
							<%
						}
			%>
			
			</table>		
			<input type="submit" name="reserve">		 
			</div>
			</form>
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