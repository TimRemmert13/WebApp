<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center">Delete Bar</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<% 

String target = request.getParameter("del_bar");
String user = session.getAttribute("active_user").toString();
if(target.equals("0")){
	%>
	Must select a bar to delete
	<br>
	<% 	
}
else{
	
	try{
		
		//load DB
		Driver driver = new Driver();
		Connection con = driver.getConnection();
		//create SQL statement
		String query = "delete from regulars where drinker = ? and bar = ?";
		PreparedStatement stm = con.prepareStatement(query);
		stm.setString(1,user);
		stm.setString(2,target);
		//insert data
		stm.executeUpdate();
		con.close();
		%>
		Bar Successfully Deleted! You can verify that the bar has been deleted by pressing the button return to
		profile page and looking under the table value bars you regular at.
		<%
		
	}catch(Exception e){
		e.printStackTrace();
	}
	
}
%>
<form name ="return" action ="profile.jsp" method = "Post">
<input type = "hidden" name= "user" value="<%=user%>" />
	<input type ="submit" value ="return to profile page" />
	
	</form> 
</body>
</html>