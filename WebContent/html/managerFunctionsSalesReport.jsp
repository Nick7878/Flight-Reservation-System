<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, java.sql.Date, java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat, java.text.DateFormat"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Sales Report</title>
<link rel = "stylesheet" href = "../css/createAccountStyle.css"><!-- Will change the css file later! -->
</head>
<body>
	<%
	try{
		String january = "01";
		String February = "02";
		String March = "03";
		String April = "04";
		String May = "05";
		String June = "06";
		String July = "07";
		String August = "08";
		String September = "09";
		String October = "10";
		String November = "11";
		String December = "12";
		
		String[][] months = new String[][]{{"January", "01"}, {"February", "02"}, {"March", "03"}, {"April", "04"}, {"May", "05"}, {"June", "06"}, {"July", "07"}, {"August", "08"}, {"September", "09"}, {"October", "10"}, {"November", "11"}, {"December", "12"}};
		
		String month = "01";
		
		if(request.getParameter("value") != null) {
			for(int monthIndex = 0; monthIndex < 12; monthIndex++) {
				System.out.println(request.getParameter("value"));
				if(request.getParameter("value").equals(months[monthIndex][1])) {
					month = months[monthIndex][1];
				}
			}
		}
		
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
		System.out.println(month);
		
		String str = "SELECT flightNum, airline, airportTo, airportFrom, fares, stops, departureDate, departureTime, arrivalDate, arrivalTime FROM flight";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		
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
			</tr>
		<%
		
		while(result.next()) {
			//Convert the date we got from the Database to a String so we can compare it to our month string.
			Date departureDate = result.getDate("departureDate");
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");  
			String strDate = dateFormat.format(departureDate);
			
			System.out.println("substring: " + strDate.substring(5,7));
			System.out.println("Departure date: " + departureDate);
			
			if(strDate.substring(5,7).equals(month)) {
				%>
				<tr>
					<td><%=result.getInt("flightNum") %></td>
					<td><%=result.getString("airline") %></td>
					<td><%=result.getString("airportTo") %></td>
					<td><%=result.getString("airportFrom") %></td>
					<td><%=result.getInt("fares") %></td>
					<td><%=result.getInt("stops") %></td>
					<td><%=result.getDate("departureDate") %></td>
					<td><%=result.getTime("departureTime") %></td>
					<td><%=result.getDate("arrivalDate") %></td>
					<td><%=result.getTime("arrivalTime") %></td>
				</tr>
				<%
			}
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