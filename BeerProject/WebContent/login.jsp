<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center">Welcome To the Social Network for Drinkers</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<form action ="profile.jsp" method ="POST">
			<Strong> Login here: </Strong>
		<select class = "form-control" name = "user" onchange= "this.form.submit();">
			<option value ="0">Select User</option>
			<% try{
				//get DB connection
				Driver driver = new Driver();
				Connection con = driver.getConnection();
			    Statement stm = con.createStatement();
			    ResultSet rs = stm.executeQuery("select name from drinkers");
			    while(rs.next()){
			    	%>
			    	<option><%=rs.getString("name") %></option>
			    	<%
			    }
			    con.close();
			    rs.close();
			}
			catch(Exception e){
				e.printStackTrace();
			}
			%>
			</select>
			<br>
			</form>
			Constraints can be seen when creating an account. If you do not fill out a field or enter a correct age 
			your request to create an account will be rejected.
			<form action = "create_user.jsp" method ="POST">
			<input type ="submit" value ="Create new account" align = "center"/>
			</form>

</body>
</html>