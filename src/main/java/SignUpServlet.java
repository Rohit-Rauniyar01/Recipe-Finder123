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
        String password = request.getParameter("password");

        if (email.equalsIgnoreCase("kalu@admin.com")) {
            response.sendRedirect("Signup.jsp?error=Admin account cannot be created manually.");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        PreparedStatement checkUser = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

            // ✅ Check if user already exists
            String checkSql = "SELECT email FROM users WHERE email = ?";
            checkUser = con.prepareStatement(checkSql);
            checkUser.setString(1, email);
            if (checkUser.executeQuery().next()) {
                response.sendRedirect("Signup.jsp?error=User already exists.");
                return;
            }

            // Insert user if email not taken
            String sql = "INSERT INTO users (username, email, password, role) VALUES (?, ?, ?, 'user')";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);

            int rowsInserted = ps.executeUpdate();
            if (rowsInserted > 0) {
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setMaxInactiveInterval(30 * 60);

                Cookie userCookie = new Cookie("username", username);
                userCookie.setMaxAge(7 * 24 * 60 * 60);
                response.addCookie(userCookie);

                response.sendRedirect("Login.jsp?success=Account created successfully! Please login.");
            } else {
                response.sendRedirect("Signup.jsp?error=Signup failed, please try again.");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            response.sendRedirect("Signup.jsp?error=Database error, please try again.");
        } finally {
            try { if (checkUser != null) checkUser.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (con != null) con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
