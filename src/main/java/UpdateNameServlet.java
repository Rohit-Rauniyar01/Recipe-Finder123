

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Servlet implementation class UpdateNameServlet
 */
@WebServlet("/UpdateNameServlet")
public class UpdateNameServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateNameServlet() {
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
		 HttpSession session = request.getSession(false);
	        if (session == null || session.getAttribute("username") == null) {
	            response.sendRedirect("Login.jsp"); // Redirect to login if session is not active
	            return;
	        }

	        String newName = request.getParameter("newName");
	        String oldUsername = (String) session.getAttribute("username");

	        Connection conn = null;
	        PreparedStatement stmt = null;

	        try {
	            // Database connection setup
	            Class.forName("com.mysql.cj.jdbc.Driver");
	            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

	            // ✅ Update query
	            String sql = "UPDATE users SET username = ? WHERE username = ?";
	            stmt = conn.prepareStatement(sql);
	            stmt.setString(1, newName);
	            stmt.setString(2, oldUsername);

	            int rowsUpdated = stmt.executeUpdate();
	            if (rowsUpdated > 0) {
	                session.setAttribute("username", newName); // Update session attribute
	                response.sendRedirect("EditName.jsp?success=Name updated successfully");
	            } else {
	                response.sendRedirect("EditName.jsp?error=Could not update name. Try again.");
	            }
	        } catch (ClassNotFoundException | SQLException e) {
	            e.printStackTrace();
	            response.sendRedirect("EditName.jsp?error=Database error.");
	        } finally {
	            // Close resources
	            try { if (stmt != null) stmt.close(); } catch (SQLException e) {}
	            try { if (conn != null) conn.close(); } catch (SQLException e) {}
	        }
	    }

}
