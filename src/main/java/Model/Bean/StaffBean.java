package Model.Bean;
import java.io.Serializable;

public class StaffBean implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected int staff_code;
	protected String staff_name;
	protected String staff_id;
	protected String staff_pass;
	protected boolean admin;
	
	public StaffBean() {
	}

	public int getStaff_code() {
		return staff_code;
	}

	public void setStaff_code(int staff_code) {
		this.staff_code = staff_code;
	}

	public String getStaff_name() {
		return staff_name;
	}

	public void setStaff_name(String staff_name) {
		this.staff_name = staff_name;
	}

	public String getStaff_id() {
		return staff_id;
	}

	public void setStaff_id(String staff_id) {
		this.staff_id = staff_id;
	}

	public String getStaff_pass() {
		return staff_pass;
	}

	public void setStaff_pass(String staff_pass) {
		this.staff_pass = staff_pass;
	}

	public boolean isAdmin() {
		return admin;
	}

	public void setAdmin(boolean admin) {
		this.admin = admin;
	}
}
