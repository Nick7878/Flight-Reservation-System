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
		
		//Get all parameters to populate the table 
		String populationTable = "select email, accountPassword, lastName, firstName, address, city, state, zipCode, telephone, creditCardNum FROM accounts JOIN customer USING(accountNum) WHERE accountNum = '" + accountNum + "';";
		ResultSet result = stmt.executeQuery(populationTable);
		
		
		if(result.next()){
	%> 
		
	<main>

    <!--Preferences-->
 <form action="myAccountChangeEmailPassword.jsp" method="get">
    <dl>
      <dt>
        <div id="pref">
          <table>
            <th> Change Email/Password </th>
            <th> </th>
            <tr>
              <td> Email Address </td>
              <td>
                  <input type="text" id="email" name="email" value="<%=result.getString("email")%>" >
              </td>
            </tr>
            <tr>
              <td> Password </td>
              <td>
                <input type="text" id="pass" name="password" value="<%=result.getString("accountPassword")%>">
              </td>
            </tr>
            <tr>
              <td>
                <input type="submit" name="Change Password">
              </td>
            </tr>
          </table>
        </div>
      </dt>
    </dl>
</form>

<form action="myAccountInfoChange.jsp" method="get" >
    <dl>
      <dt>
        <div id="priv">
          <table>
            <th> Change Personal Info </th>
            <th> </th>
            <tr>
              <td>First Name</td>
              <td>
                <input type="text" id="fname" name="firstname" value="<%=result.getString("firstName")%>">
              </td>
            </tr>
            <tr>
              <td>Last Name </td>
              <td>
                <input type="text" id="lname" name="lastname" value="<%=result.getString("lastName")%>">
              </td>
            </tr>
            <tr>
              <td> Address </td>
              <td>
                <input type="text" id="address" name="address" value="<%=result.getString("address")%>">
              </td>
            </tr>
            <tr>
              <td> City </td>
              <td>
                <input type="text" id="city" name="cityname" value="<%=result.getString("city")%>">
              </td>
            </tr>
            <tr>
              <td> State </td>
              <td>
                <input type="text" id="state" name="statename" value="<%=result.getString("state")%>" maxlength="2">
              </td>
            </tr>
            <tr>
              <td> Zip Code </td>
              <td>
                <input type="text" id="zip" name="zipcode" value="<%=result.getString("zipCode")%>" maxLength="5">
              </td>
            </tr>
            <tr>
              <td> Phone Number </td>
              <td>
                <input type="text" id="phone" name="phonenumber" value="<%=result.getString("telephone")%>" maxlength="10" >
              </td>
            </tr>
            <tr>
              <td> Credit Card Number</td>
              <td>
                <input type="text" id="card" name="creditcard" value="<%=result.getString("creditCardNum")%> " maxlength="16">
              </td>
            </tr>
            <tr>
              <td>
                <input type="submit" name="Change Password">
              </td>
            </tr>
          </table>
        </div>
      </dt>
    </dl>
</form>
</main>
		<%
	} else {
		%>
		<script>
			alert("Sorry, could not bring up account info!");
	    	window.location.href = "homepage.html";
		</script>
		<%	
	}
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