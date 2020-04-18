<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file = "myAccount.html" %>  
    
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <link href="../css/myAccount.css" type="text/css" rel="stylesheet" />
  <script src = ../check.js ></script>
</head>

<body>
<%

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
			
			//Get parameters from the HTML form at the login.jsp
		    String email = request.getParameter("email");
		    String password = request.getParameter("password");
		    String firstName = request.getParameter("firstname");
		    String lastName = request.getParameter("lastname");
		   	String address = request.getParameter("address");
		    String city = request.getParameter("cityname");
		    String state = request.getParameter("statename");
		    String zipCode = request.getParameter("zipcode");
		    String phoneNumber = request.getParameter("phonenumber");
		    String creditCardNumber = request.getParameter("creditcard");
		    
			if ((email.equals(""))&&(password.equals(""))){
				%>
				<script> 
				    alert("Please enter your email and password");
				    //window.location.href = "login.html";
				</script>
				<% 
			} else {
				//changed accounts to accounts
				String str = "SELECT * FROM accounts WHERE email='" + email + "' AND accountPassword='" + password + "'";
				


				//Run the query against the database.
				ResultSet result = stmt.executeQuery(str);
				//System.out.println(str);
	
				if (result.next()) {
					if(result.getBoolean("isManager")) {
						%>
						<script>
							let email = "<%=email%>";
							
							setCookie(email, true);
						</script>
						<%
					} else {
						%>
						<script>
							let email = "<%=email%>";
							
							setCookie(email, false);
						</script>
						<%
					}
					System.out.println("isManager: " + result.getBoolean("isManager"));
								
				} else {
					System.out.print("User not found");
					%>
					<script> 
				    	alert("User not found, or you entered a wrong password.");
				    	//window.location.href = "login.html";
					</script>
					<%  
				}
			}
			con.close();

		} catch (Exception e) {
			e.printStackTrace();
			%>
			<script>
				alert("Sorry, unexcepted error happens.");
		    	//window.location.href = "login.html";
			</script>
			<%			
		}
	%>




  </main>




</body>

</html>