package Model.DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;

import Model.Bean.StaffBean;

public class StaffDAO {
	final static String url = "jdbc:postgresql://localhost:5432/PayrollAdmin";
	
	
	
	public static ArrayList<StaffBean> getAllStaff() {
		DatabaseAccess.Initialize();
		ArrayList<StaffBean> staff = new ArrayList<StaffBean>();
		
		Properties props = DatabaseAccess.setConnectionProperty();
		try (Connection conn = DriverManager.getConnection(url, props)) {
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT * FROM \"PayrollSystem\".\"STAFF_MS\"");
			
			while (rs.next()) {
				StaffBean record = new StaffBean();
				record.setStaff_code(rs.getInt("STAFF_CODE"));
				record.setStaff_name(rs.getString("STAFF_NAME"));
				record.setStaff_id(rs.getString("STAFF_ID"));
				record.setStaff_pass(rs.getString("STAFF_PASS"));
				if (rs.getInt("AUTHORITY_CD") > 0) 
					record.setAdmin(true);
				else 
					record.setAdmin(false);
				
				staff.add(record);
			}
		} catch(SQLException e) {
			e.printStackTrace();
		} 
		
		return staff;
	}
	
	
	
	public boolean UserExist(String staff_id, String staff_password) {
		DatabaseAccess.Initialize();
		Properties props = DatabaseAccess.setConnectionProperty();
		
		boolean userExist = false;
		
		try (Connection conn = DriverManager.getConnection(url, props)) {
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery(String.format("SELECT * FROM \"PayrollSystem\".\"STAFF_MS\" where \"STAFF_ID\"='%staff_id' and \"STAFF_PASS\"='%staff_password'", staff_id, staff_password));
			
			if (rs.next()) {
				userExist = true;
			} 
		} catch(SQLException e) {
			e.printStackTrace();
		} 
		return userExist;
	}
}
