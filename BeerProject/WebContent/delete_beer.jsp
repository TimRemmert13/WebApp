<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center"> Delete Beer</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<% 

String target = request.getParameter("del_beer");
String user = session.getAttribute("active_user").toString();
if(target.equals("0")){
	%>
	Must select a beer to delete
	<br>
	<% 	
}
else{
	
	try{
		
		//load DB
		Driver driver = new Driver();
		Connection con = driver.getConnection();
		//create SQL statement
		String query = "delete from likes where drinker = ? and beer = ?";
		PreparedStatement stm = con.prepareStatement(query);
		stm.setString(1,user);
		stm.setString(2,target);
		//insert data
		stm.executeUpdate();
		con.close();
		%>
		Beer Successfully Deleted! You can verify that the beer has been deleted by pressing the button return to
		profile page and looking under the table beers liked
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