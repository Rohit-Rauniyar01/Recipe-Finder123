<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Settings - Change Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f3f2f2;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 50px;
        }

        h2 {
        	margin-right: 65%;
            font-size: 28px;
            margin-bottom: 10px;
        }

        .form-container {
            padding: 30px 40px;
            text-align: center;
        }

        .form-container h3 {
            font-weight: bold;
            margin-bottom: 20px;
        }

        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 16px;
            text-align: center;
        }

        input[type="submit"] {
            padding: 12px 30px;
            margin-top: 10px;
            font-size: 16px;
            border-radius: 6px;
            border: 1px solid #888;
            background-color: white;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #eee;
        }

        .message {
            margin-top: 15px;
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

<%
    String message = "";

    if(request.getMethod().equalsIgnoreCase("post")) {
        String username = (String) session.getAttribute("username"); // assuming user is logged in
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if(!newPassword.equals(confirmPassword)) {
            message = "New password and confirm password do not match!";
        } else {
            Connection conn = null;
            PreparedStatement pst = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

                pst = conn.prepareStatement("SELECT * FROM Users WHERE username=? AND password=?");
                pst.setString(1, username);
                pst.setString(2, currentPassword);
                rs = pst.executeQuery();

                if(rs.next()) {
                    pst = conn.prepareStatement("UPDATE Users SET password=? WHERE username=?");
                    pst.setString(1, newPassword);
                    pst.setString(2, username);
                    int updated = pst.executeUpdate();

                    if(updated > 0) {
                        message = "Password changed successfully!";
                    } else {
                        message = "Password update failed!";
                    }
                } else {
                    message = "Incorrect current password!";
                }

            } catch(Exception e) {
                message = "Error: " + e.getMessage();
            } finally {
                try { if(rs != null) rs.close(); } catch(Exception e) {}
                try { if(pst != null) pst.close(); } catch(Exception e) {}
                try { if(conn != null) conn.close(); } catch(Exception e) {}
            }
        }
    }
%>

<h2>Setting</h2>
<div class="form-container">
    <h3>Change Passwords</h3>
    <form method="post" action="ChangePassword.jsp">
    <div class="message"><%= message %></div>
        <input type="password" name="currentPassword" placeholder="Current password" required><br>
        <input type="password" name="newPassword" placeholder="New password" required><br>
        <input type="password" name="confirmPassword" placeholder="Confirm password" required><br>
        <input type="submit" value="Change it">
    </form>
    
</div>

</body>
</html>
