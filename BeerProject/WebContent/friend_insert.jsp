<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center">Add Friend</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<% 
String user = session.getAttribute("active_user").toString();
String friend = request.getParameter("friend");
if(friend.equals("0")){
	%>
	Must select a user
	<br>
	<% 	
}
else{
	
	try{
		
		//load DB
		Driver driver = new Driver();
		Connection con = driver.getConnection();
		//create SQL statement
		String query = "insert into friends (drinker,friend) values(?,?)";
		PreparedStatement stm = con.prepareStatement(query);
		PreparedStatement stm2 = con.prepareStatement(query);
		stm.setString(1,user);
		stm.setString(2,friend);
		stm2.setString(1,friend);
		stm2.setString(2,user);
		//insert data
		stm.executeUpdate();
		stm2.executeUpdate();
		con.close();
		%>
		New friend Successfully added! You can verify that your new friend has been added by pressing the button return to
		profile page and looking under the table value friends.
		<%
		
	}catch(SQLException e){
		if(e.getErrorCode() == 1062){
			%>
			User is already your friend!
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