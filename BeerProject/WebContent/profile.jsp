<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, db_connector.Driver"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page  import="java.awt.*" %>
<%@ page  import="java.io.*" %>
<%@ page  import="org.jfree.chart.*" %>
<%@ page  import="org.jfree.chart.axis.*" %>
<%@ page  import="org.jfree.chart.entity.*" %>
<%@ page  import="org.jfree.chart.labels.*" %>
<%@ page  import="org.jfree.chart.plot.*" %>
<%@ page  import="org.jfree.chart.renderer.category.*" %>
<%@ page  import="org.jfree.chart.urls.*" %>
<%@ page  import="org.jfree.data.category.*" %>
<%@ page  import="org.jfree.data.general.*" %>
<%@ page  import="machine_learning.*" %>
<!DOCTYPE hyml>
<html>
<head>
<%
String active_user = null;
active_user = request.getParameter("user");
%>
<h2 align = "center">Welcome <%=active_user%> to Your Drinker Profile</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body>
	To get everything you want to know about a bar ranging from basic information such as address and phone number
	to statistics such as average age of customers and graphs of how busy the bar is each click the button below
	that says "Get bar information now".
	<br>
	<form action = "bar_info.jsp" method = "Post">
	<input type = "hidden" name= "user" value="<%=active_user%>" />
	<input type="submit" value="Get bar information now">
	</form>
	<br>
	To find bars that are having special events and filter these events by types and order the information use our bar finder!
	For example you can find all bars with live music and order them by most popular to least popular, so you know where the 
	party is at! Or you can find all bars with singles night and order them by the number of most female/male people that go. So,
	what are you waiting for click on the button below that says "Use bar Finder" now and find out what happening around you!
	<br>
	<form name ="bar_finder" action ="bar_finder.jsp" method = "Post">
	<input type = "hidden" name= "user" value="<%=active_user%>" />
	<input type ="submit" value ="Use Bar Finder" />
	</form> 
	<br>
	<form action = "login.jsp" method = "POST">
	<input type = "submit" value = "signout"/>
	</form>
	<br>

			<table>
				<tr>
					<th>name</th>
					<th>address</th>
					<th>phone number</th>
					<th>regular customer at</th>
					<th>occupation</th>
					<th>friends</th>
					<th>age</th>
			<%
				try{
			//initialize values
			String name = null;
			String address = null;
			String phone = null;
			ArrayList<String> bars = new ArrayList<String>();
			String occ = null;
			ArrayList<String> friends = new ArrayList<String>();
			int age = 0;
			
			//connect to DB
			Driver driver = new Driver();
			Connection con = driver.getConnection();
			//get user input
			String input = request.getParameter("user");
			session.setAttribute("active_user", input);
			//creat SQL statements
			Statement stm = con.createStatement();
			Statement stm2 = con.createStatement();
			Statement stm3 = con.createStatement();
			//Execute queries
			ResultSet basic = stm.executeQuery("select * from drinkers where name ="+"'"+input +"'");
			ResultSet reg_bars = stm2.executeQuery("select bar from regulars where drinker ="+"'"+input +"'");
			ResultSet friend_list = stm3.executeQuery("select friend from friends where drinker ="+"'"+input +"'");
			while(basic.next()){
				name = basic.getString("name");
				address = basic.getString("address");
				phone = basic.getString("phone");
				occ = basic.getString("occupation");
				age = basic.getInt("age");
			}
			while(reg_bars.next()){
				bars.add(reg_bars.getString("bar"));
			}
			while(friend_list.next()){
				friends.add(friend_list.getString("friend"));
			}
				%>
				<tr>
					<td><%=name%></td>
					<td><%=address%></td>
					<td><%=phone%></td>
					<td><%=bars%></td>
					<td><%=occ%></td>
					<td><%=friends%></td>
					<td><%=age%></td>
				</tr>	
				<% 
			
				}
			catch(Exception e){
				
			}
			%>
			
			</table>
			<br>
			<table>
				<tr>
					<th>beer liked</th>
					<th>bar that sells beer at cheapest price</th>
					<th>cheapest price</th>
				<tr>
			<% 
				try{
			//initialize values
			ArrayList<String> beers = new ArrayList<String>();
			ArrayList<Float> prices = new ArrayList<Float>();
			ArrayList<String> bars = new ArrayList<String>();
			
			//connect to DB
			Driver driver = new Driver();
			Connection con = driver.getConnection();
			//get user input
			String input = request.getParameter("user");
			//creat SQL statements
			Statement stm2 = con.createStatement();
			//Execute queries
			ResultSet liked_beers = stm2.executeQuery("select beer from likes where drinker ="+"'"+input +"'");
			while(liked_beers.next()){
				beers.add(liked_beers.getString("beer"));
			}
				for(int i = 0; i < beers.size(); i++){
					Statement stm = con.createStatement();
					ResultSet results = stm.executeQuery("select bar, Min(price) from sells where beer ="+"'"+beers.get(i)+"'");
					while(results.next()){
						bars.add(results.getString("bar"));
						prices.add(results.getFloat("Min(price)"));	
					}
				%>
				<tr>
					<td><%=beers.get(i) %></td>
					<td><%=bars.get(i)%></td>
					<td><%=prices.get(i) %></td>
				</tr>	
				<% 
				}
				liked_beers.close();
				con.close();
			
				}
			catch(Exception e){
				
			}
			%>
			</table>
			<br>
			<table align = "center">
				<%
				try{
					String query ="select distinct bar from regulars where ";
					ArrayList<String> friends = new ArrayList<String>();
					ArrayList<String> bars = new ArrayList<String>();
					//connect to DB
					Driver driver = new Driver();
					Connection con = driver.getConnection();
					//get user input
					String input = request.getParameter("user");
					//creat SQL statements
					Statement stm = con.createStatement();
					Statement getFriends = con.createStatement();
					//Execute queries
					ResultSet rs = getFriends.executeQuery("select distinct friend from friends where drinker ="+"'"+input +"'");
					while(rs.next()){
						friends.add(rs.getString("friend"));
					}
					if(friends.isEmpty()){
						%>
						Add friends to get recommended Bars we think you'll like
						<br>
						<%
					}
					else{
						
					//create string for query
					%>
					<tr>
					<th>Recommended Bars for You</th>
				</tr>	
					<% 
					for(int i = 0; i < friends.size(); i ++){
						if(i != friends.size()-1){
							query = query +"drinker ="+"'"+friends.get(i)+"'"+" or ";
						}
						else{
							query = query+"drinker =" +"'"+friends.get(i)+"'";
						}
					}
					ResultSet actual = stm.executeQuery(query);
					while(actual.next()){
						bars.add(actual.getString("bar"));
					}
					for(int k = 0; k < bars.size(); k++){
						%>
						<tr>
							<td><%=bars.get(k) %></td>
						</tr>
						<% 
					}
					
					}	
				}catch(Exception e){
					e.printStackTrace();
				}
				%>
			</table>
			<br>
			<table align = "center">
				<%
				try{
					String query ="select distinct beer from likes where ";
					ArrayList<String> friends = new ArrayList<String>();
					ArrayList<String> beers = new ArrayList<String>();
					//connect to DB
					Driver driver = new Driver();
					Connection con = driver.getConnection();
					//get user input
					String input = request.getParameter("user");
					//creat SQL statements
					Statement stm = con.createStatement();
					Statement getFriends = con.createStatement();
					//Execute queries
					ResultSet rs = getFriends.executeQuery("select distinct friend from friends where drinker ="+"'"+input +"'");
					while(rs.next()){
						friends.add(rs.getString("friend"));
					}
					if(friends.isEmpty()){
						%>
						Add Friends to get recommended Beers we think you'll like
						<br>
						
						<% 
					}
					else{
						
					%>
						<tr>
							<th>Recommended Beers for You</th>
						</tr>
					<%
					//create string for query
					for(int i = 0; i < friends.size(); i ++){
						if(i != friends.size()-1){
							query = query+"drinker =" +"'"+friends.get(i)+"'"+" or ";
						}
						else{
							query = query+"drinker =" +"'"+friends.get(i)+"'";
						}
					}
					ResultSet actual = stm.executeQuery(query);
					while(actual.next()){
						beers.add(actual.getString("beer"));
					}
					for(int k = 0; k < beers.size(); k++){
						%>
						<tr>
							<td><%=beers.get(k) %></td>
						</tr>
						<% 
					}
					
					}
				}catch(Exception e){
					e.printStackTrace();
				}
				%>
			</table>
			<br>
			<table align = "center">
				<%
				try{
					String query ="select distinct friend from friends where ";
					ArrayList<String> friends = new ArrayList<String>();
					ArrayList<String> recom_friends = new ArrayList<String>();
					//connect to DB
					Driver driver = new Driver();
					Connection con = driver.getConnection();
					//get user input
					String input = request.getParameter("user");
					//creat SQL statements
					Statement stm = con.createStatement();
					Statement getFriends = con.createStatement();
					//Execute queries
					ResultSet rs = getFriends.executeQuery("select distinct friend from friends where drinker ="+"'"+input+"'");
					while(rs.next()){
						friends.add(rs.getString("friend"));
					}
					if(friends.isEmpty()){
						%>
						Add friends and build your social network to get recommended users we think you know
						<br>
						<%
					}
					else{
						
					%>
					<tr>
						<th>Users You May Know</th>
				    </tr>
					<%
					//create string for query
					for(int i = 0; i < friends.size(); i ++){
						if(i != friends.size()-1){
							query = query +"drinker =" +"'"+friends.get(i)+"'"+" or ";
						}
						else{
							query = query +"drinker ="+"'"+friends.get(i)+"'";
						}
					}
					ResultSet actual = stm.executeQuery(query);
					while(actual.next()){
						recom_friends.add(actual.getString("friend"));
					}
					for(int k = 0; k < recom_friends.size(); k++){
						%>
						<tr>
							<td><%=recom_friends.get(k) %></td>
						</tr>
						<% 
					}
					}
					
				}catch(Exception e){
					e.printStackTrace();
				}
				%>
			</table>
			</form>
			<br>
			<table>
				<tr> 
					<th>Top 10 most popular beers in NJ</th>
					<th>Number of beers sold</th>
					<th>Top 10 most popular bars in NJ</th>
					<th>Number of customers</th>
					<th>Top 10 most popular users</th>
					<th>Number of friends</th>
				</tr>
				<%
				 try{
						//get DB connection
						ArrayList<String> beers = new ArrayList<String>();
						ArrayList<Integer> num_beers = new ArrayList<Integer>();
						ArrayList<String> bars = new ArrayList<String>();
						ArrayList<Integer> num_bars = new ArrayList<Integer>();
						ArrayList<String> users = new ArrayList<String>();
						ArrayList<Integer> num_friends = new ArrayList<Integer>();
						//connect
						Driver driver = new Driver();
						Connection con = driver.getConnection();
					    Statement stm = con.createStatement();
					    ResultSet rs = stm.executeQuery("Select distinct beer, sum(sold) from sells Group by beer order by sum(sold) desc limit 10;");
					    while(rs.next()){
					    		beers.add(rs.getString("beer"));
					    		num_beers.add(rs.getInt("sum(sold)"));
					    }
					    Statement stm2 = con.createStatement();
					    ResultSet r_bar = stm2.executeQuery("Select distinct bar, sum(turnout) from events Group by bar order by sum(turnout) desc limit 10;");
					    while(r_bar.next()){
					    		bars.add(r_bar.getString("bar"));
					    		num_bars.add(r_bar.getInt("sum(turnout)"));
					    }
					    Statement stm3 = con.createStatement();
					    ResultSet r_friend = stm3.executeQuery("Select distinct drinker, count(friend) from friends Group by drinker order by count(friend) desc limit 10;");
					    while(r_friend.next()){
					    		users.add(r_friend.getString("drinker"));
					    		num_friends.add(r_friend.getInt("count(friend)"));
					    }
					    for(int i = 0; i < 10; i ++){
					    	%>
					    	<tr>
					    		<td><%=beers.get(i) %></td>
					    		<td><%=num_beers.get(i) %></td>
					    		<td><%=bars.get(i) %></td>
					    		<td><%=num_bars.get(i) %></td>
					    		<td><%=users.get(i) %></td>
					    		<td><%=num_friends.get(i) %></td>
					    	</tr>	
					    	<%
					    }   
					   con.close();
					   rs.close();
					   r_bar.close();
					   r_friend.close();
				 }catch(Exception e){
					    	e.printStackTrace();
					    }
				
					%>		
					
			</table>
			<br>
			<form name ="insert_friend" action ="friend_insert.jsp" method ="POST">
		<Strong> Add Friend: </Strong>
		<select class = "form-control" name = "friend" >
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
			<input type ="submit" value = "Add Friend"/>
			</form>
			<br>
			<form name ="insert_bar" action ="insert_bar.jsp" method ="POST">
		<Strong> Add bar you are a regular at: </Strong>
		<select class = "form-control" name = "bar">
			<option value ="0">Select Bar</option>
			<% try{
				//get DB connection
				Driver driver = new Driver();
				Connection con = driver.getConnection();
			    Statement stm = con.createStatement();
			    ResultSet rs = stm.executeQuery("select name from bars");
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
			<input type ="submit" value = "Add Bar"/>
			</form>
			<br>
			<form name ="insert_beer" action ="insert_beer.jsp" method ="POST">
		<Strong> Add new beer you like: </Strong>
		<select class = "form-control" name = "beer" >
			<option value ="0">Select Beer</option>
			<% try{
				//get DB connection
				Driver driver = new Driver();
				Connection con = driver.getConnection();
			    Statement stm = con.createStatement();
			    ResultSet rs = stm.executeQuery("select name from beers");
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
			<input type ="submit" value = "Add Beer"/>
			</form>
			<br>
			<form name ="delete" action ="delete_beer.jsp" method ="POST">
		<Strong> Delete Beer From likes: </Strong>
		<select class = "form-control" name = "del_beer" >
			<option value ="0">Select Beer</option>
			<% try{
				//get DB connection
				Driver driver = new Driver();
				Connection con = driver.getConnection();
			    Statement stm = con.createStatement();
			    String user = session.getAttribute("active_user").toString();
			    ResultSet rs = stm.executeQuery("select beer from likes where drinker = " +"'"+user+"'");
			    while(rs.next()){
			    	%>
			    	<option><%=rs.getString("beer") %></option>
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
			<input type ="submit" value = "Delete"/>
			</form>
			<br>
			<form name ="delete" action ="delete_bar.jsp" method ="POST">
		<Strong> Delete Bar From list of Bars your a regular at: </Strong>
		<select class = "form-control" name = "del_bar" >
			<option value ="0">Select Beer</option>
			<% try{
				//get DB connection
				Driver driver = new Driver();
				Connection con = driver.getConnection();
			    Statement stm = con.createStatement();
			    String user = session.getAttribute("active_user").toString();
			    ResultSet rs = stm.executeQuery("select bar from regulars where drinker = " +"'"+user+"'");
			    while(rs.next()){
			    	%>
			    	<option><%=rs.getString("bar") %></option>
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
			<input type ="submit" value = "Delete"/>
			</form>
			<br>
			<form name ="delete" action ="delete_friend.jsp" method ="POST">
		<Strong> Delete Friend From list of Friends: </Strong>
		<select class = "form-control" name = "del_friend">
			<option value ="0">Select Beer</option>
			<% try{
				//get DB connection
				Driver driver = new Driver();
				Connection con = driver.getConnection();
			    Statement stm = con.createStatement();
			    String user = session.getAttribute("active_user").toString();
			    ResultSet rs = stm.executeQuery("select friend from friends where drinker = " +"'"+user+"'");
			    while(rs.next()){
			    	%>
			    	<option><%=rs.getString("friend") %></option>
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
			<input type ="submit" value = "Delete"/>
			</form>
			Never Drink alone again! We match you will other users so you can find the right drinking buddy!
			Each user is assigned a drinker compatablity score which is based off of the number of beers you 
			and the other user likes, so the higher the compatability score, the more likely you are to share common taste
			in beers. this list of  Matched Drinking buddies are all users that like the same beers as you and the drinker compatibilty rating
			is the number of beers you both like. Find the drinking buddy of your dreams today!
			<br>
			<% 
			try{
				//get DB connection
				ArrayList<String> beers = new ArrayList<String>();
				ArrayList<String> drinkers = new ArrayList<String>();
				ArrayList<String> all_beers = new ArrayList<String>();
				HashMap<String, Integer> result = new HashMap<String,Integer>();
				HashMap<String,String> phones = new HashMap<String,String>();
				Driver driver = new Driver();
				Connection con = driver.getConnection();
			    Statement stm = con.createStatement();
			    String user = session.getAttribute("active_user").toString();
			    ResultSet r_beers = stm.executeQuery("Select distinct beer from likes where drinker = "+"'"+user+"';");
			    while(r_beers.next()){
			    		beers.add(r_beers.getString("beer"));
			    }
			    if(beers.isEmpty()){
			    	%>  <br>
			    		Add beers you like to get matched with other users who also like the same beer.
			    		<br>
			    	
			    	<% 
			    }
			    else{
			    Statement stm2 = con.createStatement();
			    Statement stm3 = con.createStatement();
			    ResultSet all = stm2.executeQuery("select * from likes");
			    ResultSet phone = stm3.executeQuery("select name, phone from drinkers");
			    while(all.next()){
			    		if(all.getString("drinker").equals(user)){
			    			continue;
			    		}
			    		else{
			    		drinkers.add(all.getString("drinker"));
			    		all_beers.add(all.getString("beer"));
			    		}
			    }
			    while(phone.next()){
		    		if(phone.getString("name").equals(user)){
		    			continue;
		    		}
		    		else{
		    			phones.put(phone.getString("name"), phone.getString("phone"));
		    		}
		    }
			    for(int i =0; i < all_beers.size(); i ++){
			    		if(beers.contains(all_beers.get(i))){
			    			if(result.containsKey(drinkers.get(i))){
			    				result.put(drinkers.get(i), result.get(drinkers.get(i)) +1);	
			    			}
			    			else{
			    				result.put(drinkers.get(i),1);
			    			}
			    		}
			    }
			    %>
			    <table>
			    		<tr> 
			    			<th>Matched Drinking Buddy</th>
			    			<th>Phone number</th>
			    			<th>Drinker compatablity rating</th>
			    		</tr>
			    	
			    <% 
			    
			    for(String drinker: result.keySet()){
			    		%>
			    		<tr>
			    			<td><%=drinker%></td>
			    			<td><%=phones.get(drinker) %></td>
			    			<td><%=result.get(drinker) %></td>
			    		</tr>		
			    		<%
			    }
			    
			    
			    %>
			    
			    </table>
			    
			    <% 
				con.close();
			    all.close();
			    r_beers.close();
			    }
			}
			catch(Exception e){
				e.printStackTrace();
			}
			
			
			%>
			<form action ="delete_user.jsp" method = "POST">
			<input type="submit" value="Delete my user account">
			</form>
			Data Patterns shown in plots below
			<br>
			<br>
	<% 
final DefaultCategoryDataset dataset = new DefaultCategoryDataset();
try{
	//load DB
	Driver driver = new Driver();
	Connection con = driver.getConnection();
	//create SQL statement
	String query = "Select distinct day, Avg(sold) from sells Group by day;";
	Statement stm = con.createStatement();
	ResultSet rs = stm.executeQuery(query);
	while(rs.next()){
		dataset.addValue(rs.getFloat("Avg(sold)"),rs.getString("day"),"");
	}
	
	//insert data
	con.close();
	rs.close();
	
}catch(Exception e){
	e.printStackTrace();
		
	}

  JFreeChart barChart = ChartFactory.createBarChart(
	         "Average Number of beers sold per day for every Bar", 
	         "Day of the Week", "Number of Beers sold", 
	         dataset,PlotOrientation.VERTICAL, 
	         true, true, false);
  
  try {
	  final ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
      final File file1 = new File(getServletContext().getRealPath(".") + "/BarChart.png");
      ChartUtilities.saveChartAsPNG(file1, barChart, 600, 400, info);
  } catch (Exception e) {
 out.println(e);
  }
%>


  Pattern verified: Average number of beers sold on Friday or Saturday is higher than any other day of the week
  <br>
  <IMG SRC= "BarChart.png" WIDTH="600" 
  HEIGHT="400" BORDER="0" USEMAP="#chart">
  <br>
  <% 
final DefaultCategoryDataset e_dataset = new DefaultCategoryDataset();
try{
	//load DB
	Driver driver = new Driver();
	Connection con = driver.getConnection();
	//create SQL statement
	String query = "Select distinct day, Avg(turnout) from events Group by day;";
	Statement stm = con.createStatement();
	ResultSet rs = stm.executeQuery(query);
	while(rs.next()){
		e_dataset.addValue(rs.getFloat("Avg(turnout)"),rs.getString("day"),"");
	}
	
	//insert data
	con.close();
	rs.close();
	
}catch(Exception e){
	e.printStackTrace();
		
	}

  JFreeChart eventChart = ChartFactory.createBarChart(
	         "Average Number of people going to events per day for every bar", 
	         "Day of the Week", "Number of people who went to event", 
	         e_dataset,PlotOrientation.VERTICAL, 
	         true, true, false);
  
  try {
	  final ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
      final File file1 = new File(getServletContext().getRealPath(".") + "/EventChart.png");
      ChartUtilities.saveChartAsPNG(file1, eventChart, 600, 400, info);
  } catch (Exception e) {
 out.println(e);
  }
%>


  Pattern verified: Average Number of people who attend events at bars is highest on Fridays and Saturdays
  <br>
  <IMG SRC= "EventChart.png" WIDTH="600" 
  HEIGHT="400" BORDER="0" USEMAP="#chart">
  <br>
</body>
</html>