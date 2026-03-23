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
			conn.close();
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
			conn.close();
		} catch(SQLException e) {
			e.printStackTrace();
		} 
		return userExist;
	}
	
	public static void UpdateStaff(StaffBean staff) throws Exception{
		DatabaseAccess.Initialize();
		Properties props = DatabaseAccess.setConnectionProperty();
		
		try (Connection conn = DriverManager.getConnection(url, props)) {
			Statement st = conn.createStatement();
			String sql = String.format("UPDATE \"PayrollSystem\".\"STAFF_MS\" "
					+ "SET \"STAFF_NAME\"='%s', "
					+ "\"STAFF_ID\"='%s', "
					+ "\"STAFF_PASS\"='%s', "
					+ "\"AUTHORITY_CD\"= %d"
					+ " WHERE \"STAFF_CODE\"= " + staff.getStaff_code(), 
					staff.getStaff_name(), staff.getStaff_id(), staff.getStaff_pass(), staff.isAdmin() ? 1 : 0);
			st.execute(sql);
			
			conn.close();
		} catch(SQLException e) {
			System.out.println(e.getMessage());
			throw e;
		} 
	}
	
	public static void InsertStaff(StaffBean staff) throws Exception{
		DatabaseAccess.Initialize();
		Properties props = DatabaseAccess.setConnectionProperty();
		
		try (Connection conn = DriverManager.getConnection(url, props)) {
			Statement st = conn.createStatement();
			String sql = "INSERT INTO \"PayrollSystem\".\"STAFF_MS\""
					+ "(\"STAFF_NAME\",\"STAFF_ID\",\"STAFF_PASS\",\"AUTHORITY_CD\") "
					+ " VALUES ('"+ staff.getStaff_name() + "', '" + staff.getStaff_id() + "', '" + staff.getStaff_pass() + "', " + (staff.isAdmin()?1:0) + ");";
			
			System.out.println(sql);
			st.execute(sql);
			
			conn.close();
		} catch(SQLException e) {
			throw e;
		} 
	}
	
	public static void DeleteStaff(String staff_id) throws Exception{
		DatabaseAccess.Initialize();
		Properties props = DatabaseAccess.setConnectionProperty();
		
		try (Connection conn = DriverManager.getConnection(url, props)) {
			Statement st = conn.createStatement();
			st.execute(String.format("DELETE FROM \"PayrollSystem\".\"STAFF_MS\" "
					+ "WHERE \"STAFF_ID\"= '%s'", staff_id));
			
			conn.close();
		} catch(SQLException e) {
			throw e;
		} 
	}
}
