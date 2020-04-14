 <%@page import ="java.sql.DriverManager"%>
 <%@page import ="java.sql.ResultSet"%>
 <%@page import ="java.sql.Statement"%>
 <%@page import ="java.sql.Connection"%> 
 <%@page import = "java.sql.PreparedStatement" %>
 <%@page contentType = "text/html" pageEncoding = "UTF-8"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.Date,java.sql.*"%>
<%@ page import=" java.util.regex.Pattern"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head> </head>
<p><br></p>
<%

try{
	
} catch(Exception e) {
	e.printStackTrace();
}
PreparedStatement stmt = null;
String host = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
Class.forName("com.mysql.jdbc.Driver");
Connection conn = DriverManager.getConnection(host, "root", "gameboy*1");


%>
<form action ="" method = "post">
	<%
	Statement statement = conn.createStatement();
	String accountNumber = request.getParameter("u");
	int accountNum = Integer.parseInt(accountNumber);
	String customersWithAccountNumQuery = "SELECT * FROM customer WHERE accountNum = " + accountNum;
	ResultSet resultSet = statement.executeQuery(customersWithAccountNumQuery);
	while(resultSet.next()){
	%>
	<input type = "hidden" name = "accNum" value = <%=resultSet.getString("accountNum") %> />
	<div class = "form-group">
		<label> Last Name </label>
		<input type = "text" class = "form-control" name = "lastName" value = <%=resultSet.getString("lastName") %> />
	</div>
	
	<div class = "form-group">
		<label> First Name</label>
		<input type = "text" class = "form-control" name = "firstName" value = <%=resultSet.getString("firstName") %> />
	</div>
	
	<div class = "form-group">
		<label> AddresultSets </label>
		<input type = "text" class = "form-control" name = "address" value = <%=resultSet.getString("addresultSets") %> />
	</div>
	
	<div class = "form-group">
		<label> City</label>
		<input type = "text" class = "form-control" name = "city" value = <%=resultSet.getString("city") %> />
	</div>
	
	<div class = "form-group">
		<label> State </label>
		<input type = "text" class = "form-control" name = "state" value = <%=resultSet.getString("state") %> />
	</div>
	
	<div class = "form-group">
		<label> Zipcode</label>
		<input type = "text" class = "form-control" name = "zip" value = <%=resultSet.getString("zipCode") %> />
	</div>
	
	<div class = "form-group">
		<label> Telephone</label>
		<input type = "text" class = "form-control" name = "telephone" value = <%=resultSet.getString("telephone") %> />
	</div>
	
	<div class = "form-group">
		<label> Credit Card Number</label>
		<input type = "text" class = "form-control" name = "creditCard" value = <%=resultSet.getString("creditCardNum") %> />
	</div>
	<%
	}
	%>
	<button type = "submit" class = "btnwa"> Update</button>
	<a href = "managerTest.jsp" class = "btn-def"> Back </a>
	</form>
<%
String z = request.getParameter("accNum");
String a = request.getParameter("lastName");
String b = request.getParameter("firstName");
String c = request.getParameter("address");
String d = request.getParameter("city");
String e = request.getParameter("state");
String f = request.getParameter("zip");
String g = request.getParameter("telephone");
String h = request.getParameter("creditCard");

if(a!=null && b!=null && c!=null && d!=null && e!=null&& f!=null && g!=null && h !=null){
	%>
	<script>
		alert("Please make sure all fields have values!");
		window.location.href = "managerEdit.jsp";
	</script>
	<%
	String query = "UPDATE customer SET lastName = ?, firstName = ?, address = ?, city = ?, state = ?, zipCode = ?, telephone = ?, creditCardNum = ? WHERE accountNum = " + z;
	stmt = conn.prepareStatement(query);
	stmt.setString(1,a);
	stmt.setString(2,b);
	stmt.setString(3,c);
	stmt.setString(4,d);
	stmt.setString(5,e);
	stmt.setString(6,f);
	stmt.setString(7,g);
	stmt.setString(8,h);
	stmt.executeUpdate();
	%>
	<script>
		alert("Update Successful!");
	</script>
	<%
	response.sendRedirect("managerTest.jsp");
}


%>
</html>
