package Model.DAO;

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
}
