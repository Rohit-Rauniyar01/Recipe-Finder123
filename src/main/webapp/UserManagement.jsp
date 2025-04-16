<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        h2 {
            color: #333;
            margin-top: 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        th {
            background-color: #f8f9fa;
            font-weight: 500;
            color: #555;
        }
        
        tr:hover {
            background-color: #f9f9f9;
        }
        
        .delete-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        
        .delete-btn:hover {
            background-color: #c82333;
        }
        
        .no-users {
            text-align: center;
            padding: 20px;
            color: #666;
        }
        
        .error-message {
            color: #dc3545;
            padding: 10px;
            background-color: #f8d7da;
            border-radius: 4px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
	<%@ include file = "BackButton.jsp" %>
    <div class="container">
        <h2><i class="fas fa-users-cog"></i> User Management</h2>

        <table>
            <tr>
                <th>ID</th>
                <th>Username</th>
                <th>Email</th>
                <th>Action</th>
            </tr>

            <%
                try {
                    // Load MySQL JDBC Driver
                    Class.forName("com.mysql.cj.jdbc.Driver");

                    // Connect to the database
                    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

                    // Query to get username and email from users table
                    String query = "SELECT id, username, email FROM users";
                    PreparedStatement ps = conn.prepareStatement(query);
                    ResultSet rs = ps.executeQuery();

                    // If no users are found, display a message
                    if (!rs.isBeforeFirst()) {
                        out.println("<tr><td colspan='4' class='no-users'>No users found.</td></tr>");
                    }

                    // Loop through the result set and display users
                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String username = rs.getString("username");
                        String email = rs.getString("email");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= username %></td>
                <td><%= email %></td>
                <td>
                    <form action="DeleteUserServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this user?');">
                            <i class="fas fa-trash-alt"></i> Delete
                        </button>
                    </form>
                </td>
            </tr>
            <%
                    }
                    // Close database resources
                    rs.close();
                    ps.close();
                    conn.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
                }
            %>
        </table>
    </div>

    <script>
        // Simple confirmation for delete
        function confirmDelete() {
            return confirm('Are you sure you want to delete this user?');
        }
    </script>
</body>
</html>