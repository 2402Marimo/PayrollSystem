package Controller.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import Message.DisplayMessage;
import Model.Bean.StaffBean;
import Model.Bean.PayrollBean;
import Model.共有.StaffLogic;
import Model.共有.PayrollLogic;

/**
 * Servlet implementation class PayrollAdminServlet
 */
@WebServlet("/PayrollServlet")
public class PayrollServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PayrollServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PayrollLogic payrollLogic = new PayrollLogic();
		if (request.getParameter("from").equals("menu")) {
			StaffBean loggedInStaff = (StaffBean) request.getSession().getAttribute("loggedInStaff"); 
	    	int staff_code = loggedInStaff.getStaff_code();
			request.getSession().setAttribute("staff_payroll", payrollLogic.getPayrollList(staff_code));
			response.sendRedirect("View/payrollInfo.jsp?");
		} else {
			request.getSession().setAttribute("staff_payroll", payrollLogic.getAllPayrollList());
			response.sendRedirect("View/payrollAdmin.jsp?");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String[] staff_codes = request.getParameterValues("staff_codes");
		String[] salaries = request.getParameterValues("salaries");
		String payroll_date = request.getParameter("payroll_date");
		String jsonResponse = "";
		List<PayrollBean> payrolls = new ArrayList<>();
		
		PayrollLogic payrollLogic = new PayrollLogic();
		List<PayrollBean> sameYearPayrolls = payrollLogic.getPayrollListYearMonth(payroll_date);
		
		for (int i=0; i<staff_codes.length;i++) {
			PayrollBean payroll = new PayrollBean();
			payroll.setDate(payroll_date);
			payroll.setStaff_code(Integer.parseInt(staff_codes[i]));
			payroll.setPayroll(Integer.parseInt(salaries[i]));
			payrolls.add(payroll);
		}
		
		for (int i=payrolls.size()-1 ; i >= 0 ; i--){
			final int index = i;
			boolean isUpdated = sameYearPayrolls.stream()
					.anyMatch(e -> e.getStaff_code() == payrolls.get(index).getStaff_code() 
					&& e.getDate().substring(0, 6).equals(payrolls.get(index).getDate()) 
					&& e.getPayroll()==payrolls.get(index).getPayroll());
			
			if (isUpdated)
				payrolls.remove(index);
		}
		
		response.setContentType("application/json; charset=UTF-8");
	    response.setCharacterEncoding("UTF-8");
	    
		if (payrolls.size() > 0) {
			try {
				payrollLogic.updatePayroll(payrolls);
				StaffLogic staffLogic = new StaffLogic();
				ArrayList<StaffBean> staffs = staffLogic.getStaffList(); 
				List<ReturnData> temp = new ArrayList<>();
				
				for (PayrollBean each : payrolls) {
					StaffBean staff = staffs.stream().filter(s -> s.getStaff_code() == each.getStaff_code()).collect(Collectors.toList()).get(0);
		        	String staff_name = staff.getStaff_name();
		        	String staff_id = staff.getStaff_id();
		        	
		        	temp.add(new ReturnData(each.getStaff_code(), staff_id, staff_name, each.getDate(), each.getPayroll()));
				}
				
				String message = "";
				
				for (ReturnData each : temp) {
					message += DisplayMessage.getMessageData("INF0014", new String[] {each.staff_name, each.payroll_date.substring(0, 4), each.payroll_date.substring(4), String.valueOf(each.salary)}) + "<br>";
				}
				
				List<PayrollBean> allPayrolls = payrollLogic.getAllPayrollList();
				request.getSession().removeAttribute("staff_payroll");
				request.getSession().setAttribute("staff_payroll", allPayrolls);
				
				jsonResponse = "{\"status\": 200, \"message\":\""+message+"\"}"; 
			} catch (Exception e) {
				e.printStackTrace();
				jsonResponse = "{\"status\": 400}"; 
			}
		} else {
			jsonResponse = "{\"status\": 201}"; 
		}
			
		
		try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
            out.flush();
        } catch(Exception ex) {
        	throw ex;
        }
	}

	class ReturnData {
    	public String staff_id, staff_name, payroll_date;
    	public int staff_code, salary;

		public ReturnData(int staff_code, String staff_id, String staff_name, String payroll_date,
				int salary) {
			super();
			this.staff_code = staff_code;
			this.staff_id = staff_id;
			this.staff_name = staff_name;
			this.payroll_date = payroll_date;
			this.salary = salary;
		}
		
		public String getStaff_id() {
			return this.staff_id.toLowerCase();
		}
    }
}
