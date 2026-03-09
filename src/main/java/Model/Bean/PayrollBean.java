package Model.Bean;
import java.io.Serializable;

public class PayrollBean implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int staff_code;
	private String date;
	private int payroll;
	
	public PayrollBean() {
	}

	public int getStaff_code() {
		return staff_code;
	}

	public void setStaff_code(int staff_code) {
		this.staff_code = staff_code;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public int getPayroll() {
		return payroll;
	}

	public void setPayroll(int payroll) {
		this.payroll = payroll;
	}
	
	
	
	
}
