<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/login.css">

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login</title>
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
		    
			if ((email.equals(""))&&(password.equals(""))){
				%>
				<script> 
				    alert("Please enter your email and password");
				    window.location.href = "login.html";
				</script>
				<% 
			} else {
				String str = "SELECT * FROM accounts WHERE email='" + email + "' AND accountPassword='" + password + "'";
	
				//Run the query against the database.
				ResultSet result = stmt.executeQuery(str);
				//System.out.println(str);
	
				if (result.next()) {
					//close the connection.
					%>
					<script> 
			    		window.location.href = "html/homepage.html";
					</script>
					<%				
				} else {
					out.print("User not found");
					%>
					<script> 
				    	alert("User not found, or you entered a wrong password.");
				    	window.location.href = "html/login.html";
					</script>
					<%  
				}
			}
			con.close();

		} catch (Exception e) {
			out.print("failed");
			%>
			<script> 
		    	alert("Sorry, unexcepted error happens.");
		    	window.location.href = "login.jsp";
			</script>
			<%			
		}
	%>

</body>
</html>