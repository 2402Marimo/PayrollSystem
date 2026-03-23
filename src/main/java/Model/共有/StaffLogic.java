package Model.共有;

import Model.DAO.StaffDao;

import java.util.ArrayList;
import java.util.stream.Collectors;

import Model.Bean.StaffBean;

public class StaffLogic {
	private ArrayList<StaffBean> staffList = new ArrayList<>();

	public StaffLogic() {
		staffList = StaffDao.getAllStaff();
	}
	
	public ArrayList<StaffBean> getStaffList() {
		return staffList;
	}

	public boolean GetStaffByLogin(String staff_id, String staff_pass) {
		return staffList.stream()
				.anyMatch(s -> s.getStaff_id().equals(staff_id) && s.getStaff_pass().equals(staff_pass));
	}
	
	public boolean GetStaffByCodeAndPassword(int staff_code, String staff_pass) {
		return staffList.stream()
				.anyMatch(s -> s.getStaff_code() == staff_code && s.getStaff_pass().equals(staff_pass));
	}

	public StaffBean GetStaffData(String staff_id) {
		return staffList.stream().filter(s -> s.getStaff_id().equals(staff_id)).collect(Collectors.toList()).get(0);
	}
	
	public boolean CheckUserExistById(String staff_id) {
		return staffList.stream()
				.anyMatch(s -> s.getStaff_id().equals(staff_id));
	}

	public boolean setStaffData(StaffBean updateStaff) throws Exception {
		try {
			if (!CheckUserExistById(updateStaff.getStaff_id())) {
				StaffDao.UpdateStaff(updateStaff);
				return true;
			} else {
				if (GetStaffData(updateStaff.getStaff_id()).getStaff_code() == updateStaff.getStaff_code()) {
					StaffDao.UpdateStaff(updateStaff);
					return true;
				} else
					return false;
			}
		} catch (Exception e) {
			throw e;
		}	
	}

	public boolean insertStaffData(StaffBean staff) throws Exception {
		try {
			if (!CheckUserExistById(staff.getStaff_id())) {
				StaffDao.InsertStaff(staff);
				return true;
			} else {
				return false;
			}
		} catch (Exception e) {
			throw e;
		}
	}

	public boolean deleteStaffData(String staff_id) throws Exception {
		try {
			StaffDao.DeleteStaff(staff_id);
			return true;
		} catch (Exception e) {
			throw e;
		}
	}
}
