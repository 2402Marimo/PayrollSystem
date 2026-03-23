package Controller.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

import Model.Bean.StaffBean;
import Model.共有.StaffLogic;

/**
 * Servlet implementation class StaffInfoServlet
 */
@WebServlet("/StaffInfoServlet")
public class StaffInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    final String TYPE_UPDATE = "update";
    final String TYPE_INSERT = "insert";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StaffInfoServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if (request.getParameter("isDisp").equals("true")) {
			response.sendRedirect("View/staffInfo.jsp?title=" + 
					request.getParameter("title") + "&staff_id=" + 
					request.getParameter("staff_id") + "&from=" + request.getParameter("from"));
		}
		else {
			StaffLogic staffLogic = new StaffLogic();
			StaffBean staff = staffLogic.GetStaffData(request.getParameter("staff_id"));
			String jsonResponse = "";
	        response.setContentType("application/json; charset=SJIS;");
	        
	        jsonResponse = "{\"staff_id\": \""
	        		+ staff.getStaff_id() 
	        		+ "\", \"staff_name\":\"" 
	        		+ staff.getStaff_name() 
	        		+ "\", \"staff_password\":\"" 
	        		+ staff.getStaff_pass()
	        		+ "\", \"authority_cd\":" 
	        		+ String.valueOf(staff.isAdmin() ? 1 : 0)
	        		+ ", \"staff_code\":" 
	        		+ staff.getStaff_code()
	        		+"}"; 
	        
	        try (PrintWriter out = response.getWriter()) {
	            out.print(jsonResponse);
	            out.flush();
	        } catch(Exception ex) {
	        	throw ex;
	        }
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		StaffLogic staffLogic = new StaffLogic();
		String jsonResponse = "";
		if (request.getParameter("type").equalsIgnoreCase(TYPE_UPDATE)) {
			boolean allow = staffLogic.GetStaffByCodeAndPassword(Integer.parseInt(request.getParameter("staff_code")), request.getParameter("staff_password"));
			if (!allow) {
	        	jsonResponse = "{\"status\":400, \"message\":\"INF0012\"}"; 
			} else {
				try {
					StaffBean updateStaff = new StaffBean();
					updateStaff.setStaff_code(Integer.parseInt(request.getParameter("staff_code")));
					updateStaff.setStaff_id(request.getParameter("staff_id"));
					updateStaff.setStaff_name(request.getParameter("staff_name"));
					updateStaff.setStaff_pass(request.getParameter("staff_password_new"));
					updateStaff.setAdmin(Integer.parseInt(request.getParameter("authority_cd")) == 1);
					
					if (staffLogic.setStaffData(updateStaff)) {
						StaffBean loggedInStaff = (StaffBean) request.getSession().getAttribute("loggedInStaff");
						
						if (updateStaff.getStaff_code() == loggedInStaff.getStaff_code()) {
							loggedInStaff.setStaff_id(updateStaff.getStaff_id());
							loggedInStaff.setStaff_name(updateStaff.getStaff_name());
							loggedInStaff.setAdmin(updateStaff.isAdmin());
							
							//　Session Re-set if updating self
				            request.getSession().setAttribute("loggedInStaff", loggedInStaff);
						}
			        	jsonResponse = "{\"status\":200, \"message\":\"INF0007\"}"; 
					} else {
						jsonResponse = "{\"status\":400, \"message\":\"INF0013\"}"; 
					}
				} catch (Exception ex) {
					jsonResponse = "{\"status\":400, \"message\":\"INF0017\"}";
				}
			}
		} else if (request.getParameter("type").equalsIgnoreCase(TYPE_INSERT)) {
			try {
				StaffBean insertStaff = new StaffBean();
				insertStaff.setStaff_code(Integer.parseInt(request.getParameter("staff_code")));
				insertStaff.setStaff_id(request.getParameter("staff_id"));
				insertStaff.setStaff_name(request.getParameter("staff_name"));
				insertStaff.setStaff_pass(request.getParameter("staff_password_new"));
				insertStaff.setAdmin(Integer.parseInt(request.getParameter("authority_cd")) == 1);
				
				if (staffLogic.insertStaffData(insertStaff)) {
					jsonResponse = "{\"status\":200, \"message\":\"INF0006\"}"; 
				} else {
					jsonResponse = "{\"status\":400, \"message\":\"INF0013\"}"; 
				}
	        	
			} catch (Exception ex) {
				ex.printStackTrace();
				 jsonResponse = "{\"status\":400, \"message\":\"INF0017\"}";
			}
		} 
		
		 try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse);
            out.flush();
        } catch(Exception ex) {
        	throw ex;
        }
	}

}
