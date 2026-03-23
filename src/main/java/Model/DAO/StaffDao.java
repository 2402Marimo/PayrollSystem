package Model.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import Model.Bean.StaffBean;

public class StaffDao {
	public static ArrayList<StaffBean> getAllStaff() {
		ArrayList<StaffBean> staff = new ArrayList<StaffBean>();
		String sql = "SELECT * FROM \"PayrollSystem\".\"STAFF_MS\"";
	
		try (Connection conn = DatabaseAccess.initiateDataSource().getConnection(); 
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			
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
	
	
	
	/*
	 * public static boolean UserExist(String staff_id, String staff_password) {
	 * boolean userExist = false; String sql =
	 * "SELECT * FROM \"PayrollSystem\".\"STAFF_MS\" where \"STAFF_ID\"=? and \"STAFF_PASS\"=?"
	 * ; try (Connection conn = DatabaseAccess.initiateDataSource().getConnection();
	 * PreparedStatement ps = conn.prepareStatement(sql)) { ps.setString(1,
	 * staff_id); ps.setString(2, staff_password); ResultSet rs = ps.executeQuery();
	 * 
	 * if (rs.next()) { userExist = true; } } catch(SQLException e) {
	 * e.printStackTrace(); } return userExist; }
	 */
	
	public static void UpdateStaff(StaffBean staff) throws Exception{
		String sql = "UPDATE \"PayrollSystem\".\"STAFF_MS\" "
				+ "SET \"STAFF_NAME\"=?, "
				+ "\"STAFF_ID\"=?, "
				+ "\"STAFF_PASS\"=?, "
				+ "\"AUTHORITY_CD\"= ? "
				+ "WHERE \"STAFF_CODE\"= ?";
		
		try (Connection conn = DatabaseAccess.initiateDataSource().getConnection(); 
				PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, staff.getStaff_name());
			ps.setString(2, staff.getStaff_id());
			ps.setString(3, staff.getStaff_pass());
			ps.setInt   (4, staff.isAdmin() ? 1 : 0);
			ps.setInt   (5, staff.getStaff_code());
			ps.execute();
		} catch(SQLException e) {
			e.printStackTrace();
			throw e;
		} 
	}
	
	public static void InsertStaff(StaffBean staff) throws Exception{
		String sql = "INSERT INTO \"PayrollSystem\".\"STAFF_MS\""
				+ "(\"STAFF_NAME\",\"STAFF_ID\",\"STAFF_PASS\",\"AUTHORITY_CD\") "
				+ " VALUES (?, ?, ?, ?);";
		
		try (Connection conn = DatabaseAccess.initiateDataSource().getConnection(); 
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, staff.getStaff_name());
			ps.setString(2, staff.getStaff_id());
			ps.setString(3, staff.getStaff_pass());
			ps.setInt(4, staff.isAdmin() ? 1 : 0);
			ps.execute();
		} catch(SQLException e) {
			throw e;
		} 
	}
	
	public static void DeleteStaff(String staff_id) throws Exception{
		String sql = "DELETE FROM \"PayrollSystem\".\"STAFF_MS\" WHERE \"STAFF_ID\"= ?";
		
		try (Connection conn = DatabaseAccess.initiateDataSource().getConnection(); 
				PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, staff_id);
			ps.execute();
		} catch(SQLException e) {
			throw e;
		} 
	}
}
