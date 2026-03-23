package Model.共有;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import Model.Bean.PayrollBean;
import Model.DAO.PayrollDAO;


public class PayrollLogic {
	private List<PayrollBean> payrollList = new ArrayList<>();

	public PayrollLogic() {
		payrollList = PayrollDAO.getAllPayroll();
	}
	
	public List<PayrollBean> getAllPayrollList() {
		return payrollList;
	}
	
	public List<PayrollBean> getPayrollList(int staff_code) {
		List<PayrollBean> staffPayroll = payrollList.stream().filter(p -> p.getStaff_code() == staff_code).collect(Collectors.toList());
		return staffPayroll;
	}
	
	public void updatePayroll(List<PayrollBean> payrolls) throws Exception {
		PayrollDAO.UpdateStaff(payrolls);
	}
	
	public List<PayrollBean> getPayrollListYearMonth(String yearMonth) {
		return payrollList.stream().filter(p -> p.getDate().substring(0, 6).equals(yearMonth)).collect(Collectors.toList());
	}
}
