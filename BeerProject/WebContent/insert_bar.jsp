<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center">Add Bar</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<% 
String user = session.getAttribute("active_user").toString();
String bar = request.getParameter("bar");
if(bar.equals("0")){
	%>
	Must select a bar
	<br>
	<% 	
}
else{
	
	try{
		
		//load DB
		Driver driver = new Driver();
		Connection con = driver.getConnection();
		//create SQL statement
		String query = "insert into regulars (bar,drinker) values(?,?)";
		PreparedStatement stm = con.prepareStatement(query);
		stm.setString(1,bar);
		stm.setString(2,user);
		//insert data
		stm.executeUpdate();
		con.close();
		%>
		New Bar Successfully added! You can verify that the bar has been added by pressing the button return to
		profile page and looking under the table value bars you regular at.
		<%
		
	}catch(SQLException e){
		if(e.getErrorCode() == 1062){
			%>
			You are already a regular at this bar! 
			<% 
		}
	}
	
}
%>
<form name ="return" action ="profile.jsp" method = "Post">
<input type = "hidden" name= "user" value="<%=user%>" />
	<input type ="submit" value ="return to profile page" />
	
	</form> 
</body>
</html>