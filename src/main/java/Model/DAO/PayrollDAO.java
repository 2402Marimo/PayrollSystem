package Model.DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Model.Bean.PayrollBean;


public class PayrollDAO {
	final static String url = "jdbc:postgresql://localhost:5432/PayrollAdmin";
	
	public static ArrayList<PayrollBean> getAllPayroll() {
		ArrayList<PayrollBean> payrolls = new ArrayList<PayrollBean>();
		
		String sql = "SELECT"
				+ " \"STAFF_CODE\", \"SALARY\","
				+ " TO_CHAR(\"PAYROLL_DATE\", 'YYYYMMDD') AS formatted_date"
				+ " FROM \"PayrollSystem\".\"TB_PAYROLL\"";

		try (Connection conn = DatabaseAccess.initiateDataSource().getConnection(); 
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {
			
			while (rs.next()) {
				PayrollBean record = new PayrollBean();
				record.setStaff_code(rs.getInt("STAFF_CODE"));
				record.setDate(rs.getString("formatted_date"));
				record.setPayroll(rs.getInt("SALARY"));
				
				payrolls.add(record);
			}

		} catch(SQLException e) {
			e.printStackTrace();
		} 
		
		return payrolls;
	}
	
	public static void setPayrollData(List<PayrollBean> payrolls) throws Exception{
		String sql = "UPDATE \"PayrollSystem\".\"TB_PAYROLL\""
				+ " SET \"SALARY\"= ?" 
				+ " WHERE \"STAFF_CODE\"= ?" 
				+ " AND TO_CHAR(\"PAYROLL_DATE\", 'YYYYMM') = ?"; 
		
		try (Connection conn = DatabaseAccess.initiateDataSource().getConnection(); 
				PreparedStatement ps = conn.prepareStatement(sql)) {
		
			for (PayrollBean each : payrolls) {
				ps.setInt(1, each.getPayroll());
				ps.setInt(2, each.getStaff_code());
				ps.setString(3, each.getDate());
				
				ps.addBatch();
			}
			
			ps.executeBatch();
			
		} catch(SQLException e) {
			System.out.println(e.getMessage());
			throw e;
		} 
	}
}
