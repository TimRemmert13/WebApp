<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align ="center"> Create New Account
</h2>
<body>
Create a New User Account
			<br>
			*Note to create a user you must fill out all fields below and age must be at least 21 and less than 100
			<br>
			<form name = "myForm" action ="create.jsp" method = "POST">
				<table border = "0">
					<tbody>
						<tr>
							<td> User name:</td>
							<td> <input type = "text" name = "user" value = "" size = "50"/></td>
						</tr>
						<tr>
							<td> address:</td>
							<td> <input type = "text" name = "address" value = "" size = "50"/></td>
						</tr>
						<tr>
							<td> Phone number:</td>
							<td> <input type = "text" name = "phone" value = "" size = "50"/></td>
						</tr>
						<tr>
							<td> occupation:</td>
							<td> <input type = "text" name = "occupation" value = "" size = "50"/></td>
						</tr>
						<tr>
							<td> age</td>
							<td> <input type = "text" name = "age" value = "" size = "10"/></td>
						</tr>
					</tbody>
				</table>
				<input type = "radio" name = "myradio" value = "Male" /> Male
				<br>
				<input type = "radio" name = "myradio" value = "Female" /> Female
				<br>
			<input type ="submit" value ="submit" />
			</form>
</body>

</html>