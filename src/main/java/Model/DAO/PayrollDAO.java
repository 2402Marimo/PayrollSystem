package Model.DAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import Model.Bean.PayrollBean;
import Model.Bean.StaffBean;


public class PayrollDAO {
	final static String url = "jdbc:postgresql://localhost:5432/PayrollAdmin";
	
	public static ArrayList<PayrollBean> getAllPayroll() {
		DatabaseAccess.Initialize();
		ArrayList<PayrollBean> payrolls = new ArrayList<PayrollBean>();
		
		Properties props = DatabaseAccess.setConnectionProperty();
		try (Connection conn = DriverManager.getConnection(url, props)) {
			Statement st = conn.createStatement();
			String sql = "SELECT"
					+ " \"STAFF_CODE\", \"SALARY\","
					+ " TO_CHAR(\"PAYROLL_DATE\", 'YYYYMMDD') AS formatted_date"
					+ " FROM \"PayrollSystem\".\"TB_PAYROLL\"";

			ResultSet rs = st.executeQuery(sql);
			
			while (rs.next()) {
				PayrollBean record = new PayrollBean();
				record.setStaff_code(rs.getInt("STAFF_CODE"));
				record.setDate(rs.getString("formatted_date"));
				record.setPayroll(rs.getInt("SALARY"));
				
				payrolls.add(record);
			}
			conn.close();
		} catch(SQLException e) {
			e.printStackTrace();
		} 
		
		return payrolls;
	}
	
	public static void UpdateStaff(List<PayrollBean> payrolls) throws Exception{
		DatabaseAccess.Initialize();
		Properties props = DatabaseAccess.setConnectionProperty();
		
		try (Connection conn = DriverManager.getConnection(url, props)) {
			Statement st = conn.createStatement();
			for (PayrollBean each : payrolls) {
				int year = Integer.valueOf(each.getDate().substring(0, 4));
				int month = Integer.valueOf(each.getDate().substring(4));
				String sql = "UPDATE \"PayrollSystem\".\"TB_PAYROLL\""
						+ " SET \"SALARY\"= " + each.getPayroll()
						+ " WHERE \"STAFF_CODE\"= " + each.getStaff_code()
						+ " AND TO_CHAR(\"PAYROLL_DATE\", 'YYYYMM') = '" + each.getDate() +"'";
				
				st.addBatch(sql);
			}
			
			st.executeBatch();
			
			conn.close();
		} catch(SQLException e) {
			System.out.println(e.getMessage());
			throw e;
		} 
	}
}
