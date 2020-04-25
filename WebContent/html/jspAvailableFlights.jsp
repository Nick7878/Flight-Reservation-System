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
	try{
	    //Gets AccountNum. If it can't, throw an error because they're not logged in
	    cookie = cookies[0];
	    int accountNum = Integer.parseInt(cookie.getValue());
	} catch(Exception e) {
		e.printStackTrace();
		%>
		<script>
			alert("Sorry, You have to be logged in to view flights");
	    	window.location.href = "homepage.html";
		</script>
		<%
	}
	
	try{
	    //Gets AccountNum
	    cookie = cookies[0];
	    int accountNum = Integer.parseInt(cookie.getValue());
	    System.out.println(accountNum);
	    
		System.out.println("Round Trip: " + request.getParameter("roundTrip"));
		session.setAttribute("numberOfPassengers", request.getParameter("numOfPassengers"));
		if(request.getParameter("roundTrip") == null) {
			session.setAttribute("round-trip", 1);
		} else {
			session.setAttribute("round-trip", request.getParameter("roundTrip"));	
		}
		session.setAttribute("fromAirport", request.getParameter("fromAirport"));
		session.setAttribute("toAirport", request.getParameter("toAirport"));
		session.setAttribute("departureDate", request.getParameter("departureDate"));
		
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
		String flightAvailableOnSpecificDayOneWayQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, CASE WHEN DATEDIFF(departureDate, CURDATE()) <= 3 THEN fares-10 WHEN DATEDIFF(departureDate, CURDATE()) <= 7 THEN fares-20 WHEN DATEDIFF(departureDate, CURDATE()) <= 14 THEN fares-40 WHEN DATEDIFF(departureDate, CURDATE()) <= 21 THEN fares-60 WHEN DATEDIFF(departureDate, CURDATE()) <= 30 THEN fares-80 END AS fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE (departureDate = '" + departureDate + "' AND '" + departureDate + "' >= CURDATE()) AND (flight.airportTo = '" + airportTo + "' AND flight.airportFrom = '" + airportFrom + "') AND (NOT ((availableSeats - " + numOfPassengers + ") < 0));";
		
		//Gets flights in a certain date range
		String flightAvailableOnCertainDateRangeOneWayQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, CASE WHEN DATEDIFF(departureDate, CURDATE()) <= 3 THEN fares-10 WHEN DATEDIFF(departureDate, CURDATE()) <= 7 THEN fares-20 WHEN DATEDIFF(departureDate, CURDATE()) <= 14 THEN fares-40 WHEN DATEDIFF(departureDate, CURDATE()) <= 21 THEN fares-60 WHEN DATEDIFF(departureDate, CURDATE()) <= 30 THEN fares-80 END AS fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE departureDate <= ADDDATE('" + departureDate + "', 3) AND departureDate >= ADDDATE('" + departureDate + "', -3) AND CURDATE() <= ADDDATE('" + departureDate + "', 3) AND CURDATE() <= ADDDATE('" + departureDate + "', -3) AND (flight.airportTo = '" + airportTo + "' AND flight.airportFrom = '" + airportFrom + "') AND (NOT ((availableSeats - '" + numOfPassengers + "') < 0));";
		
		//Gets flight for a round trip flight
		String returningFlightQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, CASE WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 3 THEN fares-10 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 7 THEN fares-20 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 14 THEN fares-40 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 21 THEN fares-60 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 30 THEN fares-80 END AS fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE (departureDate = '" + returnDate + "' AND '" + returnDate + "' >= CURDATE()) AND (flight.airportTo = '" + airportFrom + "' AND flight.airportFrom = '" + airportTo + "') AND (NOT ((availableSeats - " + numOfPassengers + ") < 0));";
				
		String returningFlightDateRangeQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, availableSeats, CASE WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 3 THEN fares-10 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 7 THEN fares-20 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 14 THEN fares-40 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 21 THEN fares-60 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 30 THEN fares-80 END AS fares, departureDate, departureTime, arrivalDate, arrivalTime FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE departureDate <= ADDDATE('" + returnDate + "', 3) AND departureDate >= ADDDATE('" + returnDate + "', -3) AND CURDATE() <= ADDDATE('" + returnDate + "', 3) AND CURDATE() <= ADDDATE('" + returnDate + "', -3) AND (flight.airportTo = '" + airportFrom + "' AND flight.airportFrom = '" + airportTo + "') AND (NOT ((availableSeats - '" + numOfPassengers + "') < 0));";
				
		System.out.println(flightAvailableOnCertainDateRangeOneWayQuery);
		
		System.out.println(returningFlightQuery);
		
		System.out.println(returningFlightDateRangeQuery);
		
				
		
		
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
				ResultSet roundTripDepartingResult = roundTripFlightStatement.executeQuery(flightAvailableOnSpecificDayOneWayQuery);
				if(!roundTripDepartingResult.next()) {
					roundTripDepartingResult = roundTripFlightStatement.executeQuery(flightAvailableOnCertainDateRangeOneWayQuery);
					if(!roundTripDepartingResult.next()) {
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
						roundTripDepartingResult.previous();
						while(roundTripDepartingResult.next()) {
							%>
							<tr>
								<td>
				                    <div class="radio">
				                         <label><input type="radio" name="one-way" value=<%=roundTripDepartingResult.getInt("flightNum") %>></label>
				                    </div>
				               	</td>
								<td><%=roundTripDepartingResult.getInt("flightNum") %></td>
								<td><%=roundTripDepartingResult.getString("airlineName") %></td>
								<td><%=roundTripDepartingResult.getString("airportTo") %></td>
								<td><%=roundTripDepartingResult.getString("airportFrom") %></td>
								<td><%=roundTripDepartingResult.getInt("availableSeats") %></td>
								<td>$<%=roundTripDepartingResult.getInt("fares") %></td>
								<td><%=roundTripDepartingResult.getDate("departureDate") %></td>
								<td><%=roundTripDepartingResult.getTime("departureTime") %></td>
								<td><%=roundTripDepartingResult.getDate("arrivalDate") %></td>
								<td><%=roundTripDepartingResult.getTime("arrivalTime") %></td>
							</tr>
							<%
						}
			%>
					</table>
					<% 
					ResultSet roundTripReturningResult = roundTripFlightStatement.executeQuery(returningFlightQuery);
					if(!roundTripReturningResult.next()) {
						roundTripReturningResult = roundTripFlightStatement.executeQuery(returningFlightDateRangeQuery);
						if(!roundTripReturningResult.next()) {
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
					%>
					
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
						roundTripReturningResult.previous();
						while(roundTripReturningResult.next()) {
					%>
							<tr>
								<td>
				                    <div class="radio">
				                         <label><input type="radio" name="round-trip" value=<%=roundTripReturningResult.getInt("flightNum") %>></label>
				                    </div>
				               	</td>
								<td><%=roundTripReturningResult.getInt("flightNum") %></td>
								<td><%=roundTripReturningResult.getString("airlineName") %></td>
								<td><%=roundTripReturningResult.getString("airportTo") %></td>
								<td><%=roundTripReturningResult.getString("airportFrom") %></td>
								<td><%=roundTripReturningResult.getInt("availableSeats") %></td>
								<td>$<%=roundTripReturningResult.getInt("fares") %></td>
								<td><%=roundTripReturningResult.getDate("departureDate") %></td>
								<td><%=roundTripReturningResult.getTime("departureTime") %></td>
								<td><%=roundTripReturningResult.getDate("arrivalDate") %></td>
								<td><%=roundTripReturningResult.getTime("arrivalTime") %></td>
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