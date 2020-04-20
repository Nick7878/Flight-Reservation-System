<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ include file = "myAccount.html" %>  
    
<!DOCTYPE html>
<html lang="en">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" type="text/css" href="css/login.css">
 
 <title>Change my account Email and Password</title>
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
	
	String firstName = request.getParameter("firstname");
	String lastName = request.getParameter("lastname");
	String address = request.getParameter("address");
	String city = request.getParameter("cityname");
	String state = request.getParameter("statename");
	String zipCode = request.getParameter("zipcode");
	String phoneNumber = request.getParameter("phonenumber");
	String creditCardNumber = request.getParameter("creditcard");
	
	String changeCustomerInfoQuery = " UPDATE customer SET lastName= ' "+ lastName +" ', firstName = '"+ firstName +" ', address = '"+ address +" ', city = '"+ city +" ', state = '"+ state +" ', zipCode = '"+ zipCode +" ', telephone = '"+ phoneNumber +" ', creditCardNum = '"+ creditCardNumber +" ' WHERE accountNum = '" + accountNum + "';";
	
	try {
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
			
		//Get parameters from the HTML form at the myAccount.jsp
		System.out.println("Change Info");
		
		con.close();
	} catch(Exception e) {
		e.printStackTrace();
		%>
		<script>
			//alert("Sorry, unexcepted error happens.");
	    	window.location.href = "homepage.html";
		</script>
		<%	
	}
%>
</body>
</html>