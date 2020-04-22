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
<p> <br> </p>
<div class = "row">
<div class = "col">
<h3>Hello There</h3>
<!--  there was once a link here goign to something we are no longer using-->
</div>

</div>




 <table class = "table">
 	<thead>
 	<tr>
 		<th> Account Number </th>
 		<th> LastName </th>
 		<th> FirstName </th>
 		<th> Address </th>
 		<th> City </th>
 		<th> State </th>
 		<th> Zipcode </th>
 		<th> Telephone </th>
 		<th> CreditCardNumber </th>
 		<th class = "text-center" > Action </th>
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
 		<td><%=res.getString("accountNum") %></td>
 		<td><%=res.getString("lastname") %></td>
 		<td><%=res.getString("firstname") %></td>
 		<td><%=res.getString("address") %></td>
 		<td><%=res.getString("city") %></td>
 		<td><%=res.getString("state") %></td>
 		<td><%=res.getString("zipCode") %></td>
 		<td><%=res.getString("telephone") %></td>
 		<td><%=res.getString("creditCardNum") %></td>
 		<td> <a href = 'jspManagerEdit.jsp?u=<%=res.getString("accountNum")%>' class = "btn w"> Edit </a>
 	</tr>
 	<%
 	}
 	%>
 	</tbody>
 </table>



</html>