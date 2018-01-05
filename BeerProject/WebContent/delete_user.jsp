<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center">Delete User</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<% 

String target = session.getAttribute("active_user").toString();
if(target.equals("0")){
	%>
	Must select a user to delete
	<br>
	<% 	
}
else{
	
	try{
		
		//load DB
		Driver driver = new Driver();
		Connection con = driver.getConnection();
		//create SQL statement
		String query = "delete from drinkers where name = ?";
		PreparedStatement stm = con.prepareStatement(query);
		stm.setString(1,target);
		//insert data
		stm.executeUpdate();
		con.close();
		%>
		User Successfully Deleted! You can verify that the user has been deleted by pressing the button return to
		login page and looking at the login drop down menu.
		<%
		
	}catch(Exception e){
		e.printStackTrace();
	}
	
}
%>
<form name ="return" action ="login.jsp" method = "Post">
	<input type ="submit" value ="return to login page" />
	
	</form> 
</body>
</html>