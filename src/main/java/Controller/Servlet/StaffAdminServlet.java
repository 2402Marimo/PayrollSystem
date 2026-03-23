package Controller.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Comparator;

import Message.DisplayMessage;
import Model.Bean.StaffBean;
import Model.共有.StaffLogic;

/**
 * Servlet implementation class StaffAdminServlet
 */
@WebServlet("/StaffAdminServlet")
public class StaffAdminServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	final String TYPE_DELETE = "delete";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StaffAdminServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		if (request.getParameter("isDisp").equals("false")) {
			StaffLogic staffLogic = new StaffLogic();
			ArrayList<StaffBean> allStaff = staffLogic.getStaffList();
			allStaff.sort(Comparator.comparing(StaffBean::getStaff_id));
			String jsonResponse = "[";
	        response.setContentType("application/json; charset=SJIS;");
	        
	        int ctr = 0;
	        for (StaffBean each : allStaff) {
	        	ctr++;
	        	jsonResponse += "{";
	        	jsonResponse += "\"staff_id\": \"" + each.getStaff_id() + "\"";
	        	jsonResponse += ",\"staff_name\": \"" + each.getStaff_name() + "\"";
				jsonResponse += "}";
				
				if (ctr < allStaff.size()) {jsonResponse += ",";}
			}
	        jsonResponse += "]";
	        	        
	        try (PrintWriter out = response.getWriter()) {
	            out.print(jsonResponse);
	            out.flush();
	        } catch(Exception ex) {
	        	throw ex;
	        }
		} else {
			response.sendRedirect("View/staffAdmin.jsp");
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		StaffLogic staffLogic = new StaffLogic();
		String jsonResponse = "";
		if (request.getParameter("type").equalsIgnoreCase(TYPE_DELETE)) {
			try {
				String staff_id = request.getParameter("staff_id");
				StaffBean deletedStaff = staffLogic.GetStaffData(staff_id);
				staffLogic.deleteStaffData(staff_id);
	        	
				String returnMessage = DisplayMessage.getMessageData("INF0009", new String[] {deletedStaff.getStaff_name(), "","",""});
	        	jsonResponse = "{\"status\":200, \"message\":\"" + returnMessage +"\"}"; 
			} catch (Exception ex) {
				String returnMessage = DisplayMessage.getMessageData("INF0017", null);
				jsonResponse = "{\"status\":400, \"message\":\"" + returnMessage +"\"}";
			}
			
			try (PrintWriter out = response.getWriter()) {
	            out.print(jsonResponse);
	            out.flush();
	        } catch(Exception ex) {
	        	throw ex;
	        }
		}
	}

}
