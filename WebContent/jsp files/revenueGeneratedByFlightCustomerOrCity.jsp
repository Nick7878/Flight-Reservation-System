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
		
		String flightNum = request.getParameter("flightNumber");
		String destinationCity = request.getParameter("city");
		String accountNum = request.getParameter("accountNumber");
		
		
		//Create a connection string
		//name the schema cs336project otherwise this url will not work!
		String url = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
		//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
		Class.forName("com.mysql.jdbc.Driver");

		//Create a connection to your DB
		//the second argument is the username, and the third argument is the password. Password will be different for everyone
		Connection con = DriverManager.getConnection(url, "root", "gameboy*1");
		
		//Create a SQL statement
		Statement customerRevenueStatement = con.createStatement();
		Statement cityRevenueStatement = con.createStatement();
		Statement flightRevenueStatement = con.createStatement();
		//Get the combobox from the HelloWorld.jsp
		System.out.println(request.getParameter("value"));
		
		String customerRevenueQuery = "SELECT firstName, lastName, accountNum, SUM(totalFare) AS totalRevenue FROM customer JOIN reservations USING(accountNum) GROUP BY accountNum HAVING accountNum = '" + accountNum + "';";
		String cityRevenueQuery = "SELECT city AS destinationCity, (((numOfSeats - availableSeats) * fares) + 20) AS totalRevenue FROM flight JOIN airport ON airportTo = airportCode GROUP BY destinationCity HAVING destinationCity = '" + destinationCity + "';";
		String flightRevenueQuery = "SELECT flightNum, airlineName, a1.airportName AS airportTo, a2.airportName AS airportFrom, numOfSeats, fares, departureDate, departureTime, arrivalDate, arrivalTime, (((numOfSeats - availableSeats) * fares) + 20) AS totalRevenue FROM flight JOIN airline ON flight.airline = airline.airlineCode JOIN airport a1 ON flight.airportTo = a1.airportCode JOIN airport a2 ON flight.airportFrom = a2.airportCode WHERE flightNum = '" + flightNum + "';";
		//Run the query against the database.
		ResultSet customerRevenueResult = customerRevenueStatement.executeQuery(customerRevenueQuery);
		ResultSet cityRevenueResult = cityRevenueStatement.executeQuery(cityRevenueQuery);
		ResultSet flightRevenueResult = flightRevenueStatement.executeQuery(flightRevenueQuery);
		
		if(!flightNum.equals("")) {
			%>
			<table style="border: 1px solid black;">
				<tr>
				<th>Flight Number</th>
				<th>Airline</th>
				<th>To Airport</th>
				<th>From Airport</th>
				<th>Fare</th>
				<th>Stops</th>
				<th>Departure Date</th>
				<th>Departure Time</th>
				<th>Arrival Date</th>
				<th>Arrival Time</th>
				<th>Total Revenue</th>
				</tr>
			<%	
			
			while(flightRevenueResult.next()) {
				%>
				<tr>
					<td><%=flightRevenueResult.getInt("flightNum") %></td>
					<td><%=flightRevenueResult.getString("airlineName") %></td>
					<td><%=flightRevenueResult.getString("airportTo") %></td>
					<td><%=flightRevenueResult.getString("airportFrom") %></td>
					<td><%=flightRevenueResult.getInt("numOfSeats") %></td>
					<td>$<%=flightRevenueResult.getInt("fares") %></td>
					<td><%=flightRevenueResult.getDate("departureDate") %></td>
					<td><%=flightRevenueResult.getTime("departureTime") %></td>
					<td><%=flightRevenueResult.getDate("arrivalDate") %></td>
					<td><%=flightRevenueResult.getTime("arrivalTime") %></td>
					<td>$<%=flightRevenueResult.getDouble("totalRevenue") %></td>
				</tr>
				<%
			}
			%>
			</table>
			<% 
			flightRevenueResult.close();
		}
		
		if(!destinationCity.equals("")) {
			%>
			<table style="border: 1px solid black;">
				<tr>
				<th>Destination City</th>
				<th>Total Revenue</th>
				</tr>
			<%	
			
			while(cityRevenueResult.next()) {
				%>
				<tr>
					<td><%=cityRevenueResult.getString("destinationCity") %></td>
					<td>$<%=cityRevenueResult.getDouble("totalRevenue") %></td>
				</tr>
				<%
			}
			%>
			</table>
			<% 
			cityRevenueResult.close();
		}
		
		if(!accountNum.equals("")) {
			%>
			<table style="border: 1px solid black;">
				<tr>
				<th>Account #</th>
				<th>First Name</th>
				<th>Last Name</th>
				<th>Total Revenue</th>
				</tr>
			<%	
			
			while(customerRevenueResult.next()) {
				%>
				<tr>
					<td><%=customerRevenueResult.getInt("accountNum") %></td>
					<td><%=customerRevenueResult.getString("firstName") %></td>
					<td><%=customerRevenueResult.getString("lastName") %></td>
					<td>$<%=customerRevenueResult.getDouble("totalRevenue") %></td>
				</tr>
				<%
			}
			%>
			</table>
			<% 
			customerRevenueResult.close();
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