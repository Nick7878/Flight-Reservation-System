<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, java.sql.Date, java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat, java.text.DateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file = "myReservationsAndFlightHistory.html" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<link rel="stylesheet" type="text/css" href="../css/myReservationsAndFlightHistoryStyle.css" />
<title>title</title>
<link rel = "stylesheet" href = "../css/genericCSS.css">

<style> table {
  border-collapse: collapse;
}

table, th, td {
  border: 1px solid black;
  
}</style>
</head>


		<h2>Upcoming Reservations</h2>

        <table style = "width: 100%;">
        <thead>
            <tr>
                <th>Reservation Code</th>
                <th>Departure Date</th>
                <th># of Passengers </th>
                <th>Reservation Type </th>
                <th>Total Cost </th>
                
            </tr>
            </thead>
            <tbody>
	<%
	//Hello
	Cookie cookie = null;
    Cookie[] cookies = null;

    // Get an array of Cookies associated with the this domain
    cookies = request.getCookies();

    //Gets AccountNum
    cookie = cookies[0];
    int accountNumFromCookie = Integer.parseInt(cookie.getValue());
    System.out.println(accountNumFromCookie);
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
		
		String str = "SELECT r.reservationCode, f.departureDate, r.passengers, CASE WHEN reservationType = 1 THEN 'One Way' WHEN reservationType = 2 THEN 'Round Trip' ELSE 'Invalid ReservationType' END AS reservationType, r.totalFare FROM flight f,reservationFlights rf ,reservations r WHERE f.flightNum = rf.flightNum AND r.reservationCode = rf.reservationCode AND f.departureDate >= CURDATE() AND r.accountNum = "  + accountNumFromCookie + " GROUP BY r.reservationCode";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		
		%>

		<%
		
		while(result.next()) {
			%>
			<tr>
				<td><%=result.getString("reservationCode") %></td>
				<td><%=result.getDate("departureDate") %></td>
				<td><%=result.getInt("passengers") %></td>
				<td><%=result.getString("reservationType") %></td>
				<td><%=result.getDouble("totalFare") %></td>
				
				<!-- Add a total revenue field from every flight -->
			</tr>
			
			<%
		}
		%>
		</tbody>
		</table>
				<h2>Past Reservations</h2>

        <table style = "width: 100%;">
        <thead>
            <tr>
                <th>Reservation Code</th>
                <th>Departure Date</th>
                <th># of Passengers </th>
                <th>Reservation Type </th>
                <th>Total Cost </th>
                
            </tr>
            </thead>
            <tbody>
	<%
	
		String str2 = "SELECT r.reservationCode, f.departureDate, r.passengers, CASE WHEN reservationType = 1 THEN 'One Way' WHEN reservationType = 2 THEN 'Round Trip' ELSE 'Invalid ReservationType' END AS reservationType, r.totalFare FROM flight f,reservationFlights rf ,reservations r WHERE f.flightNum = rf.flightNum AND r.reservationCode = rf.reservationCode AND f.departureDate <= CURDATE() AND r.accountNum = "  + accountNumFromCookie + " GROUP BY r.reservationCode";
		//Run the query against the database.
		ResultSet result2 = stmt.executeQuery(str2);
		
		%>

		<%
		
		while(result2.next()) {
			%>
			<tr>
				<td><%=result2.getString("reservationCode") %></td>
				<td><%=result2.getDate("departureDate") %></td>
				<td><%=result2.getInt("passengers") %></td>
				<td><%=result2.getString("reservationType") %></td>
				<td><%=result2.getDouble("totalFare") %></td>
				
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