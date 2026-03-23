package Model.DAO;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

import org.postgresql.ds.PGSimpleDataSource;

public class DatabaseAccess {
	final static String DB_USERNAME = "postgres";
	final static String DB_PASSWORD = "password";
	public static PGSimpleDataSource initiateDataSource() {
		PGSimpleDataSource ds = new PGSimpleDataSource();
		ds.setUrl("jdbc:postgresql://localhost:5432/PayrollAdmin");
		ds.setUser(DB_USERNAME);
		ds.setPassword(DB_PASSWORD);
		return ds;
	}
	
	public static void Initialize() {
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
