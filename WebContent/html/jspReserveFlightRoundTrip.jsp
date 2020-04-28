<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, java.sql.Date, java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat, java.text.DateFormat, java.time.LocalDateTime, java.time.format.DateTimeFormatter"%>
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
		Cookie cookie = null;
	    Cookie[] cookies = null;

	    // Get an array of Cookies associated with the this domain
	    cookies = request.getCookies();

	    //Gets AccountNum
	    cookie = cookies[0];
	    int accountNum = Integer.parseInt(cookie.getValue());
	    //gets flight number from previous page
	    String departingFlightNum = request.getParameter("one-way");
	    String returningFlightNum = request.getParameter("round-trip");
	    String departureDate = session.getAttribute("departureDate").toString();
		
		String url = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
		//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
		Class.forName("com.mysql.jdbc.Driver");

		//Create a connection to your DB
		//the second argument is the username, and the third argument is the password.
		Connection con = DriverManager.getConnection(url, "root", "gameboy*1");
		
		Statement stmt = con.createStatement();
		
		//Checks to see is current user has a reservation for the flight they're choosing. If so, don't book
		String checkForDuplicateReservationQuery = "SELECT * FROM reservationflights JOIN reservations USING(reservationCode) Where flightNum = '" + departingFlightNum + "' and accountNum = '" + accountNum + "' AND travelDate >= CURDATE();";
		ResultSet duplicateResult = stmt.executeQuery(checkForDuplicateReservationQuery);
		
		if(duplicateResult.next()) {
			%>
			<script>
				alert("You already have a reservation for this flight. Please choose another.");
		    	window.location.href = "homepage.html";
			</script>
			<%
			return;
		}
				
		//Gets last name for current account logged in
		String lastNameQuery = "SELECT lastName FROM customer WHERE accountNum = '" + accountNum + "';";
				
		ResultSet result = stmt.executeQuery(lastNameQuery);
		result.next();
		
		//Create the reservation code
		String reservationCode = result.getString("lastName").substring(0, 3).toUpperCase() + "-";
		
		for(int randomCount = 0; randomCount < 6; randomCount++) {
			int randomNum = (int)(Math.random() * 10.0);
			reservationCode += randomNum;
		}
		
		//Get necessary info to create reservation
		String getFlightInfoQuery = "SELECT departureDate, CASE WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 3 THEN fares-10 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 7 THEN fares-20 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 14 THEN fares-40 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 21 THEN fares-60 WHEN DATEDIFF('" + departureDate + "', CURDATE()) <= 30 THEN fares-80 END AS fares FROM flight WHERE flightNum IN ('" + departingFlightNum + "', '" + returningFlightNum + "') ORDER BY departureDate ASC;";
		String numberOfPassengers = session.getAttribute("numberOfPassengers").toString();
		
		ResultSet flightResult = stmt.executeQuery(getFlightInfoQuery);
		flightResult.next();
		
		int totalFare = (flightResult.getInt("fares") * Integer.parseInt(numberOfPassengers)) + 20;
		System.out.println("totalFare1: " + totalFare);
		Date travelDate = flightResult.getDate("departureDate");
		
		flightResult.next();
		
		totalFare += (flightResult.getInt("fares") * Integer.parseInt(numberOfPassengers)) + 20;
		System.out.println("totalFare2: " + totalFare);
		
		String reservationType = session.getAttribute("round-trip").toString();
		boolean internationalFlight = false;
		
		//Determine if reservation is an international flight
		String internationalFlightQuery = "SELECT country FROM airport WHERE airportCode IN ('" + session.getAttribute("fromAirport").toString() + "', '" + session.getAttribute("toAirport").toString() + "');";
		
		ResultSet internationalFlightResult = stmt.executeQuery(internationalFlightQuery);
		
		internationalFlightResult.next();
		String airportTo = internationalFlightResult.getString("country");
		internationalFlightResult.next();
		String airportFrom = internationalFlightResult.getString("country");
		
		
		if(!airportTo.equals("US") || !airportFrom.equals("US")) {
			internationalFlight = true;
		}
		
		//Create the reservation creation date
		LocalDateTime myDateObj = LocalDateTime.now();
		DateTimeFormatter myFormatObj = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

		String reservationCreationDate = myDateObj.format(myFormatObj);
		
		//Queries to insert into database
		String reserveQuery = "INSERT INTO reservations (reservationCode, totalFare, travelDate, bookFee, passengers, accountNum, reservationType, reservationCreationDate, internationalFlight)"
				+ "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?);";
				
		String reservationFlightsQuery = "INSERT INTO reservationFlights (flightNum, reservationCode, leg)"
				+ "VALUES(?, ?, ?);";
				
		PreparedStatement ps = con.prepareStatement(reserveQuery);
		
		ps.setString(1, reservationCode);
		ps.setInt(2, totalFare);
		ps.setDate(3, travelDate);
		ps.setInt(4, 20);
		ps.setInt(5, Integer.parseInt(numberOfPassengers));
		ps.setInt(6, accountNum);
		ps.setInt(7, Integer.parseInt(reservationType));
		ps.setString(8, reservationCreationDate);
		ps.setBoolean(9, internationalFlight);
		
		ps.executeUpdate();
		
		//insert into reservationFlights table
		ps = con.prepareStatement(reservationFlightsQuery);
		
		ps.setInt(1, Integer.parseInt(departingFlightNum));
		ps.setString(2, reservationCode);
		ps.setInt(3, 1);
		
		ps.executeUpdate();
		
		ps = con.prepareStatement(reservationFlightsQuery);
		
		ps.setInt(1, Integer.parseInt(returningFlightNum));
		ps.setString(2, reservationCode);
		ps.setInt(3, 2);
		
		ps.executeUpdate();
		
		//Update available seats for departing flight
		String updateAvailableSeatsDepartingQuery = "UPDATE flight SET availableSeats = (availableSeats - '" + numberOfPassengers + "') WHERE flightNum = '" + departingFlightNum + "';";
		String updateAvailableSeatsReturningQuery = "UPDATE flight SET availableSeats = (availableSeats - '" + numberOfPassengers + "') WHERE flightNum = '" + returningFlightNum + "';";
		
		stmt.executeUpdate(updateAvailableSeatsDepartingQuery);
		stmt.executeUpdate(updateAvailableSeatsReturningQuery);
		
		con.close();
		
		%>
		<script>
			alert("Successfully reserved flight! Check the My Reservations tab to see information about your reservation.");
	    	window.location.href = "jspMyReservationsAndFlightHistory.jsp";
		</script>
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