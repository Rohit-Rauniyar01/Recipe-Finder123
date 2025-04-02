import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/SignUpServlet")
public class SignUpServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SignUpServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password"); // Storing password in plaintext

        // Prevent admin account creation manually
        if (email.equalsIgnoreCase("kalu@admin.com")) {
            response.sendRedirect("Signup.jsp?error=Admin account cannot be created manually.");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            // Database connection setup
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

            // SQL query to insert new user
            String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, 'user')";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password); // Storing password as plaintext

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                // Create Session
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes

                // Create Cookie
                Cookie userCookie = new Cookie("username", username);
                userCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                response.addCookie(userCookie);

                response.sendRedirect("Login.jsp?success=Account created successfully! Please login.");
            } else {
                response.sendRedirect("Signup.jsp?error=Signup failed, please try again.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Signup.jsp?error=Database error, please try again.");
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
