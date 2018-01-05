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
<!DOCTYPE hyml>
<html>
<head>
<h2 align = "center">Get Quick information and Statistics of Bars</h2>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
</head>
<body> 
<div class = "container">
	<form action ="bar_info.jsp" method ="POST">
		<div class ="col-sm-5">
		<Strong> Get quick information of bars: </Strong>
		<select class = "form-control" name = "name" onchange= "this.form.submit();">
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
			<% 
			String user = request.getParameter("user");
			String bar = request.getParameter("name");
			if(bar == null){
				%>
				Please Select a Bar
				<br>
				<% 	
			}
			else{
			%>
			<br>
			</div>
			<table class ="table table-bordered">
				<tr> 
					<th>name</th>
					<th>address</th>
					<th>Phone</th>
					<th>busiest day</th>
					<th>average number of beers sold</th>
					<th>events held at this bar</th>
					<th>average age of regulars</th>
				</tr>
				<%
				try{
					//initialize values
					String address = null;
					String name = null;
					String phone = null;
					String day = null;
					int sold = 0;
					int age = 0;
					ArrayList<String> eve = new ArrayList<String>();
					ArrayList<String> regulars = new ArrayList<String>();
					//connect to DB
					Driver driver = new Driver();
					Connection con = driver.getConnection();
					//create SQL statements
				    Statement stm = con.createStatement();
				    Statement stm2 = con.createStatement();
				    Statement stm3 = con.createStatement();
				    Statement stm4 = con.createStatement();
				    Statement stm5 = con.createStatement();
				    Statement stm6 = con.createStatement();
				    //get user input
				    String input = request.getParameter("name");
				    //execute queries
				    ResultSet results = stm.executeQuery("select * from bars where name ="+"'"+input+"'");
				    ResultSet busy = stm2.executeQuery("Select day, avg(sold) from sells Where bar =" +"'"+input +"'" + "group by day order by avg(sold) desc limit 1;");
				    ResultSet events = stm3.executeQuery("select event from events where bar ="+"'"+input+"'");
				    ResultSet regs = stm4.executeQuery("select drinker from regulars where bar = "+"'"+input+"'");
				    ResultSet avg_age = stm5.executeQuery("select avg(age) from drinkers d, regulars r where d.name = r.drinker and r.bar ="+ "'"+input +"'");
				    ResultSet bandp = stm6.executeQuery("select beer, price from sells where bar ="+"'"+input +"'");
				    
				    //process results
				    while(results.next()){
				    		name = results.getString("name");
				    		address = results.getString("address");
				    		phone = results.getString("Phone");
				    }
				    while(busy.next()){
				    		day = busy.getString("day");
				    		sold = busy.getInt("avg(sold)");
				    }
				    while(events.next()){
				    		eve.add(events.getString("event"));
				    }
				    while(regs.next()){
				    		regulars.add(regs.getString("drinker"));
				    }
				    while(avg_age.next()){
				    		age = avg_age.getInt("avg(age)");
				    }
				    
				    //insert processed results into table
					%>
			    			<tr>
			    				<td><%=name %></td>
	    						<td><%=address %></td>
	    						<td><%=phone %></td>
	    						<td><%=day %></td>
	    						<td><%=sold %></td>
	    						<td><%=eve %></td>
	    						<td><%=age %></td>
	    					</tr>
	    				<% 
	    				//close connections and result sets
				    results.close();
	    				busy.close();
	    				events.close();
	    				regs.close();
	    				avg_age.close();
				    con.close();
				}
				catch(Exception e){
					e.printStackTrace();
				}
				%>
			</table>
			<br>
			<table style ="boder:1px solid;">
				<tr>
					<th>Beers sold at this bar</th>
					<th>Price of beer</th>
				</tr>
			<% 
			try{
			ArrayList<Float> prices = new ArrayList<Float>();
			ArrayList<String> beers = new ArrayList<String>();
			//connect to DB
			Driver driver = new Driver();
			Connection con = driver.getConnection();
			//get user input
			String input = request.getParameter("name");
			Statement stm6 = con.createStatement();
			ResultSet bandp = stm6.executeQuery("select beer, price from sells where bar ="+"'"+input +"'");
			while(bandp.next()){
				beers.add(bandp.getString("beer"));
				prices.add(bandp.getFloat("price"));
			}
			for(int i = 0; i < beers.size(); i++){
				%>
				<tr>
					<td><%=beers.get(i)%></td>
					<td><%=prices.get(i)%></td>
				</tr>	
				<% 
			}
			con.close();
			bandp.close();
			%>
			</table>
				<%
			}catch(Exception e){
				e.printStackTrace();
			}	
		
			final DefaultCategoryDataset b_dataset = new DefaultCategoryDataset();
			try{
				//load DB
				Driver driver = new Driver();
				Connection con = driver.getConnection();
				//create SQL statement
				String query = "Select distinct day, Avg(sold) from sells where bar = "+"'"+request.getParameter("name")+"' "+ "Group by day;";
				Statement stm = con.createStatement();
				ResultSet rs = stm.executeQuery(query);
				while(rs.next()){
					b_dataset.addValue(rs.getFloat("Avg(sold)"),rs.getString("day"),"");
				}
				
				//insert data
				con.close();
				rs.close();
				
			}catch(Exception e){
				e.printStackTrace();
					
				}

			  JFreeChart barChart = ChartFactory.createBarChart(
				         "Average Number of beers sold per day", 
				         "Day of the Week", "Number of Beers sold", 
				         b_dataset,PlotOrientation.VERTICAL, 
				         true, true, false);
			  
			  try {
				  final ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
			      final File file1 = new File(getServletContext().getRealPath(".") + "/Bar1Chart.png");
			      ChartUtilities.saveChartAsPNG(file1, barChart, 600, 400, info);
			  } catch (Exception e) {
			 out.println(e);
			  }
			
			%>

			  <br>
			  <IMG SRC= "Bar1Chart.png" WIDTH="600" 
			  HEIGHT="400" BORDER="0" USEMAP="#chart">
			  <br>
			  <%} %>
			  <input type ="hidden" name= "user" value ="<%=user %>"/>
			</form>
			</div>
			<br>
			<form action = "profile.jsp" method = "POST">
			<input type = "hidden" name= "user" value="<%=user%>" />
			<input type = "submit" value = "return to profile page"/>
			</form>

</body>
</html>