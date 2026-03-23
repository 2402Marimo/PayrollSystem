package Controller.Servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

import Message.DisplayMessage;
import Model.Bean.StaffBean;
import Model.共有.*;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String staff_id = request.getParameter("staff_id");
        String staff_password = request.getParameter("staff_password");
        
        StaffLogic staffLogic = new StaffLogic();
        boolean userExist = staffLogic.GetStaffByLogin(staff_id, staff_password);
        String jsonResponse = "";
        response.setContentType("application/json; charset=SJIS;");
        if (userExist) {
        	jsonResponse = "{\"status\": 200}"; 
        	StaffBean loggedInStaff = staffLogic.GetStaffData(staff_id);
        	HttpSession session = request.getSession(); 
        	session.setAttribute("loggedInStaff", loggedInStaff);
        } else {
        	String returnMessage = DisplayMessage.getMessageData("INF0003", null);
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
