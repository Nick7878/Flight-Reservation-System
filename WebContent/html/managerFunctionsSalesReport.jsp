<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file = "managerAccount.html" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Sales Report</title>
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
				if(request.getParameter("value").equals(months[monthIndex][0])) {
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
		String january = request.getParameter("value");
		System.out.println(january);
		
		String str = "SELECT flightNum, airline, airportTo, airportFrom, fares, stops, departureDate, departureTime, arrivalDate, arrivalTime FROM flight";
		//Run the query against the database.
		ResultSet result = stmt.executeQuery(str);
		
		while(result.next()) {
			System.out.println(result.getString("Airline"));
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