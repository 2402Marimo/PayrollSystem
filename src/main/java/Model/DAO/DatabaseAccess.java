package Model.DAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

public class DatabaseAccess {
	
	public static Properties setConnectionProperty() {
		final String username = "postgres";
		final String password = "password";
		
		Properties props = new Properties();
		props.setProperty("user", username);
		props.setProperty("password", password);
		return props;
	}
	
	public static void Initialize() {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void CloseConnection(Connection conn) {
		try {
			conn.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
