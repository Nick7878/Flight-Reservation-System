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
	String telephone = request.getParameter("phonenumber");
	String creditCardNum = request.getParameter("creditcard");
	
	
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
		
		String changeCustomerInfoQuery = " UPDATE customer SET lastName= ' "+ lastName +" ', firstName = '"+ firstName +" ', address = '"+ address +" ', city = '"+ city +" ', state = '"+ state +" ', zipCode = '"+ zipCode +" ', telephone = '"+ telephone +" ', creditCardNum = '"+ creditCardNum +" ' WHERE accountNum = '" + accountNum + "';";
	
		// 1. check empty
		if( firstName.equals("") || lastName.equals("") || address.equals("") || city.equals("") || state.equals("") || zipCode.equals("") || telephone.equals("") || creditCardNum.equals("")){
			System.out.println("empty detected!");
			%> 
			<!-- if error, show the alert and go back to create account page --> 
			<script> 
			    alert("Sorry, but all fields must be filled to create a new account.");
			    window.location.href = "myAccount.jsp";
			</script>
			<%
			return;
		}
		//checks if the zipcode is the correct lenght
		if(state.length() != 2) {
			System.out.println("Invalid Credit Card Number");
			%> 
			<!-- if error, show the alert and go back to create account page --> 
			<script> 
			    alert("Invalid State CODE");
			    window.location.href = "myAccount.jsp";
			</script>
			<%
			return;	
		}		
		
		//checks if the zipcode is the correct lenght
		if(telephone.length() != 5) {
			System.out.println("Invalid Credit Card Number");
			%> 
			<!-- if error, show the alert and go back to create account page --> 
			<script> 
			    alert("Invalid zipcode");
			    window.location.href = "myAccount.jsp";
			</script>
			<%
			return;	
		}			
		//checks if phonenumber is the correct lenght
		if(telephone.length() != 10) {
			System.out.println("Invalid Credit Card Number");
			%> 
			<!-- if error, show the alert and go back to create account page --> 
			<script> 
			    alert("Invalid phonenumber");
			    window.location.href = "myAccount.jsp";
			</script>
			<%
			return;	
		}
		if(creditCardNum.length() != 16) {
			System.out.println("Invalid Credit Card Number");
			%> 
			<!-- if error, show the alert and go back to create account page --> 
			<script> 
			    alert("Invalid Credit Card Number");
			    window.location.href = "myAccount.jsp";
			</script>
			<%
			return;	
		}
		stmt.executeUpdate(changeCustomerInfoQuery);
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