package db_connector;

import java.sql.*;

public class Driver {

	public Driver() {

	}

	public Connection getConnection() {
		Connection conn = null;
		try {
			try {
				//Load JDBC driver - the interface standardizing the connection procedure. Look at WEB-INF\lib for a mysql connector jar file, otherwise it fails.
				Class.forName("com.mysql.jdbc.Driver").newInstance();
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			//Get DB connection
			String url = "jdbc:mysql://beerbardrinker.caym7eupl4q6.us-east-2.rds.amazonaws.com:3306/BeerBarDrinker";
			String user = "TimRemmert";
			String pass = "Morty2012!";
			//load driver
			conn = DriverManager.getConnection(url,user,pass);

		}
		catch(Exception e) {
			e.printStackTrace();
		}
		return conn;

	}

	public void closeConnection(Connection connection){
		try {
			connection.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static void main(String[] args) {
		Driver dao = new Driver();
		Connection connection = dao.getConnection();

		
	}
}


