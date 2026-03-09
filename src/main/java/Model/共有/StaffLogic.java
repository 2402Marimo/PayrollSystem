package Model.共有;

import Model.DAO.StaffDAO;

import java.util.ArrayList;
import java.util.stream.Collectors;

import Model.Bean.StaffBean;

public class StaffLogic {
	private ArrayList<StaffBean> staffList = new ArrayList<>();
	
	public StaffLogic() {
		staffList = StaffDAO.getAllStaff();
	}
	
	public boolean GetStaffByLogin(String staff_id, String staff_pass) {
		boolean userExist = staffList.stream()
				.anyMatch(s -> s.getStaff_id().equals(staff_id) && 
                          s.getStaff_pass().equals(staff_pass));
		
		return userExist;
	}
	
	public StaffBean getStaffData(String staff_id) {
		return staffList.stream()
				.filter(s -> s.getStaff_id().equals(staff_id)).collect(Collectors.toList()).get(0);
	}
}
