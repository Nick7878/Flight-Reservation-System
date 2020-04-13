 <%@page import ="java.sql.DriverManager"%>
 <%@page import ="java.sql.ResultSet"%>
 <%@page import ="java.sql.Statement"%>
 <%@page import ="java.sql.Connection"%> 
 <%@page contentType = "text/html" pageEncoding = "UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<style> table {
  border-collapse: collapse;
}

table, th, td {
  border: 1px solid black;
}</style>
</head>

 <table class = "table">
 	<thead>
 	<tr>
 		<th> LastName </th>
 		<th> FirstName </th>
 		<th> Address </th>
 		<th> City </th>
 		<th> State </th>
 		<th> Zipcode </th>
 		<th> Telephone </th>
 		<th> CreditCardNumber </th>
 	</tr>
 	</thead>
 	<tbody>
 	<%
 	String host = "jdbc:mysql://localhost:3306/cs336project?useSSL=false";
 	Connection conn = null;
 	Statement stat = null;
 	ResultSet res = null;
 	Class.forName("com.mysql.jdbc.Driver");
 	conn = DriverManager.getConnection(host, "root", "gameboy*1");
 	stat = conn.createStatement();
 	String data = "SELECT * FROM customer";
 	res = stat.executeQuery(data);
 	while(res.next()){
 	%>
 	<tr>
 		<td><%=res.getString("lastname") %></td>
 		<td><%=res.getString("firstname") %></td>
 		<td><%=res.getString("address") %></td>
 		<td><%=res.getString("city") %></td>
 		<td><%=res.getString("state") %></td>
 		<td><%=res.getString("zipCode") %></td>
 		<td><%=res.getString("telephone") %></td>
 		<td><%=res.getString("creditCardNum") %></td>
 	</tr>
 	<%
 	}
 	%>
 	</tbody>
 </table>



</html>