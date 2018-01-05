<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center">Welcome to the Bar Finder</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<form name ="has_event" action ="bar_finder.jsp" method ="POST">
				Find all bars that have events:
				<br>
				<input type = "radio" name = "BeerBong" value = "Beer Bong" /> Beer Bong
				<br>
				<input type = "radio" name = "Darts" value = "Darts" /> Darts
				<br>
				<input type = "radio" name = "DJ" value = "DJ" /> DJ
				<br>
				<input type = "radio" name = "HappyHour" value = "Happpy Hour" /> Happy Hour
				<br>
				<input type = "radio" name = "LiveMusic" value = "Live Music" /> Live Music
				<br>
				<input type = "radio" name = "SeniorsNight" value = "Seniors Night" /> Seniors Night
				<br>
				<input type = "radio" name = "Trivia" value = "Trivia" /> Trivia
				<br>
				<input type = "radio" name = "Karaoke" value = "Karaoke" /> Karaoke
				<br>
				<input type = "radio" name = "SinglesNight" value = "Singles Night" /> Singles Night
				<br>
				Order list of Bars by:
				<br>
				<input type = "radio" name = "myradio" value = "Male" /> Most Male regulars
				<br>
				<input type = "radio" name = "myradio" value = "Female" /> Most Female regulars
				<br>
				<input type = "radio" name = "myradio" value = "cheap" /> Cheapest Beer
				<br>
				<input type = "radio" name = "myradio" value = "popular" /> Most popular
				<br>
				<input type = "radio" name = "myradio" value = "least_popular" /> Least popular
				<br>
				<%
				//create string for requested events
				String events = "";
				String user = request.getParameter("user");
				ArrayList<String> elist = new ArrayList<String>();
				if(request.getParameter("BeerBong") != null){
					events = "event ="+"'"+ request.getParameter("BeerBong")+ "'" +" or ";
					elist.add(request.getParameter("BeerBong"));
				}
				if(request.getParameter("Darts") != null){
					events = events+"event =" + "'"+request.getParameter("Darts") +"'"+" or ";
					elist.add(request.getParameter("Darts"));
				}
				if(request.getParameter("DJ") != null){
					events = events + "event ="+"'"+request.getParameter("DJ") +"'"+" or ";
					elist.add(request.getParameter("DJ"));
				}
				if(request.getParameter("HappyHour") != null){
					events = events +"event ="+ "'"+request.getParameter("HappyHour") +"'"+" or ";
					elist.add(request.getParameter("HappyHour"));
				}
				if(request.getParameter("LiveMusic") != null){
					events = events + "event ="+"'"+request.getParameter("LiveMusic") +"'"+" or ";
					elist.add(request.getParameter("LiveMusic"));
				}
				if(request.getParameter("SeniorsNight") != null){
					events = events + "event ="+"'"+request.getParameter("SeniorsNight") +"'"+" or ";
					elist.add(request.getParameter("SeniorsNight"));
				}
				if(request.getParameter("Trivia") != null){
					events = events +"event ="+ "'"+request.getParameter("Trivia") +"'"+" or ";
					elist.add(request.getParameter("Trivia"));
				}
				if(request.getParameter("Karaoke") != null){
					events = events + "event ="+"'"+request.getParameter("Karaoke") +"'"+" or ";
					elist.add(request.getParameter("Karaoke"));
				}
				if(request.getParameter("SinglesNight") != null){
					events = events +"event ="+ "'"+request.getParameter("SinglesNight") +"'"+" or ";
					elist.add(request.getParameter("SinglesNight"));
				}
				if(events != ""){
					events = events.substring(0,events.length()-4);
				}
				
				//case 1: No events selected and no order by commmands selected
				if(events == "" && request.getParameter("myradio") == null){
					%> 
					<br>
					Please select at least one event or order command
					<br>
					<% 
				}
				//case 2: No events selected but order by statement selected
				if(events == "" && request.getParameter("myradio") != null){
					String order = request.getParameter("myradio");
					if(order.equals("Male")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Number of Male regulars</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, r.bar, count(d.gender) from drinkers d, regulars r, events e where d.gender ='Male' and d.name = r.drinker and e.bar = r.bar group by event, day, bar order by count(gender) desc");
					    while(rs.next()){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getInt("count(d.gender)") %></td>
					    			</tr>	
					 		<%
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					else if(order.equals("Female")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Number of Female regulars</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, r.bar, count(d.gender) from drinkers d, regulars r, events e where d.gender ='Female' and d.name = r.drinker and e.bar = r.bar group by event, day, bar order by count(gender) desc");
					    while(rs.next()){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getInt("count(d.gender)") %></td>
					    			</tr>	
					 		<%
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					else if(order.equals("cheap")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Average price of beer</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, s.bar, avg(s.price) from sells s, events e where s.bar = e.bar group by event, day, bar order by avg(s.price)");
					    while(rs.next()){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getFloat("avg(s.price)") %></td>
					    			</tr>	
					 		<%
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					else if(order.equals("popular")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Number of people who go</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, r.bar, e.turnout from regulars r, events e where r.bar = e.bar group by event, day, bar order by e.turnout desc");
					    while(rs.next()){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getInt("turnout") %></td>
					    			</tr>	
					 		<%
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					else if(order.equals("least_popular")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Number of people who go</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, r.bar, e.turnout from regulars r, events e where r.bar = e.bar group by event, day, bar order by e.turnout");
					    while(rs.next()){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getInt("turnout") %></td>
					    			</tr>	
					 		<%
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					
				}
				
				//case three events selected and no order by command
				if(events != "" && request.getParameter("myradio")== null){
					%>
		    		<table>
		    			<tr>
		    				<th>Event</th>
		    				<th>Day of the week event is on</th>
		    				<th>Bar</th>
		    			</tr>
		    		 <%
		    		//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select event, bar, day from events where " +events);
					    while(rs.next()){
					    	%>
			    			<tr>
			    				<td><%=rs.getString("event") %></td>
			    				<td><%=rs.getString("day") %></td>
			    				<td><%=rs.getString("bar") %></td>
			    			</tr>	
			 		    <%
					    }  
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%		     
				}
				
				//case four both events and order commands selected 
				if(events != "" && request.getParameter("myradio") != null){
					String order = request.getParameter("myradio");
					if(order.equals("Male")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Number of Male regulars</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, r.bar, count(d.gender) from drinkers d, regulars r, events e where d.gender ='Male' and d.name = r.drinker and e.bar = r.bar group by event, day, bar order by count(gender) desc");
					    while(rs.next()){
					    		if(elist.contains(rs.getString("event"))){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getInt("count(d.gender)") %></td>
					    			</tr>	
					 		<%
					    		}
					    		else{
					    			continue;
					    		}
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					else if(order.equals("Female")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Number of Female regulars</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, r.bar, count(d.gender) from drinkers d, regulars r, events e where d.gender ='Female' and d.name = r.drinker and e.bar = r.bar group by event, day, bar order by count(gender) desc");
					    while(rs.next()){
					    		if(elist.contains(rs.getString("event"))){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getInt("count(d.gender)") %></td>
					    			</tr>	
					 		<%
					    		}
					    		else{
					    			continue;
					    		}
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					else if(order.equals("cheap")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Average price of beer</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, s.bar, avg(s.price) from sells s, events e where s.bar = e.bar group by event, day, bar order by avg(s.price)");
					    while(rs.next()){
					    		if(elist.contains(rs.getString("event"))){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getFloat("avg(s.price)") %></td>
					    			</tr>	
					 		<%
					    		}
					    		else{
					    			continue;
					    		}
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					else if(order.equals("popular")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Number of people who go</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, r.bar, e.turnout from regulars r, events e where r.bar = e.bar group by event, day, bar order by e.turnout desc");
					    while(rs.next()){
					    		if(elist.contains(rs.getString("event"))){
					    			
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getInt("turnout") %></td>
					    			</tr>	
					 		<%
					    		}
					    		else{
					    			continue;
					    		}
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					else if(order.equals("least_popular")){
						%>
			    		<table>
			    			<tr>
			    				<th>Event</th>
			    				<th>Day of the week event is on</th>
			    				<th>Bar</th>
			    				<th>Number of people who go</th>
			    			</tr>
			    		 <%
						//get DB connection
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("select e.event, e.day, r.bar, e.turnout from regulars r, events e where r.bar = e.bar group by event, day, bar order by e.turnout");
					    while(rs.next()){
					    		if(elist.contains(rs.getString("event"))){
					    		%>
					    			<tr>
					    				<td><%=rs.getString("event") %></td>
					    				<td><%=rs.getString("day") %></td>
					    				<td><%=rs.getString("bar") %></td>
					    				<td><%=rs.getInt("turnout") %></td>
					    			</tr>	
					 		<%
					    		}
					    		else{
					    			continue;
					    		}
					    	
					    }
					    con.close();
					    rs.close();
					    %>
					    </table>
					    <%
					}
					
				}
				
				%>
				<input type ="hidden" name= "user" value ="<%=user %>"/>
				<input type="submit" value = "Find me the bars I want!"/>
			</form>
			<form action = "profile.jsp" method = "POST">
			<input type = "hidden" name= "user" value="<%=user%>" />
			<input type = "submit" value= "return to profile page"/>
			</form>
</body>
</html>