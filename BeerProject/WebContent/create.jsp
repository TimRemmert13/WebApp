<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center">Create profile</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<% 
int age = 0;
String name = request.getParameter("user");
String address = request.getParameter("address");
String phone = request.getParameter("phone");
String occupation = request.getParameter("occupation");
String gender = request.getParameter("myradio");
if(request.getParameter("age") == ""){
	%>
	Must enter an age
	<br>
	<% 	
}
else{
	age = Integer.parseInt(request.getParameter("age"));
}
if(name.isEmpty()){
	%>
	Must enter a user name
	<br>
	<% 	
}
if(address.isEmpty()){
	%>
	Must enter an address
	<br>
	<% 	
}
if(phone.isEmpty()){
	%>
	Must enter a phone number
	<br>
	<% 	
}
if(occupation.isEmpty()){
	%>
	Must enter a occupation
	<br>
	<% 	
}
if(gender == null){
	%>
	Must select a gender
	<br>
	<% 	
}
if(age < 21 || age >=100){
	%>
	Age Must at least 21 and less than 100
	<br>
	<% 	
}
else{
	try{
		
		//load DB
		Driver driver = new Driver();
		Connection con = driver.getConnection();
		//create SQL statement
		String query = "insert into drinkers (address, phone, occupation, name, gender ,age) values(?,?,?,?,?,?)";
		PreparedStatement stm = con.prepareStatement(query);
		stm.setString(1,address);
		stm.setString(2,phone);
		stm.setString(3,occupation);
		stm.setString(4,name);
		stm.setString(5,gender);
		stm.setInt(6,age);
		stm.executeUpdate();
		//insert data
		con.close();
		
	}catch(SQLException e){
		if(e.getErrorCode() == 1062){
			%>
			User already exists!
			
			<br>
			<%
			
		}
	}
	session.setAttribute("active_user", name);
	%>
	New User Successfully added!
	<br>
	<form name ="return" action ="profile.jsp" method = "Post">
	<input type = "hidden" name= "user" value="<%=name%>" />
	<input type ="submit" value ="Go to profile page" />
	<% 



}
%>
<form action ="login.jsp" method = "Post">
	<input type ="submit" value ="Go to back to Login page"/>
	</form> 
</body>
</html>