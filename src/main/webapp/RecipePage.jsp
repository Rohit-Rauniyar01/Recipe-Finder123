<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Recipes</title>
    <link href="https://fonts.googleapis.com/css2?family=Capriola&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        body {
            font-family: Capriola, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        h1 {
            text-align: start;
            margin: 30px 0 20px 75px;
            font-size: 24px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

		 /* Header Section */
        .page-header {
            padding: 20px 5%;
            background-color: var(--white);
            box-shadow: var(--shadow-sm);
            position: relative;
        }
        
        .page-title {
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 1.8rem;
            color: var(--primary-color);
        }
        
        .page-title i {
            font-size: 1.5rem;
        }
		
        .recipe-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            padding: 20px;
            justify-content: center;
        }

        .recipe-card {
            background: white;
            padding: 15px;
            border-radius: 12px;
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.1);
            text-align: center;
            position: relative;
            width: 90%;
            max-width: 320px;
            margin: auto;
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
            will-change: transform;
        }

        .recipe-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }

        .recipe-card img {
            width: 100%;
            height: 200px;
            border-radius: 8px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .recipe-card:hover img {
            transform: scale(1.02);
        }

        .recipe-card h3 {
            margin: 12px 0;
            color: #333;
            font-size: 18px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .fav-icon {
            font-size: 24px;
            position: absolute;
            top: 22px;
            right: 22px;
            cursor: pointer;
            color: rgba(255,255,255,0.8);
            text-shadow: 0 1px 3px rgba(0,0,0,0.3);
            transition: all 0.2s ease;
            z-index: 10;
        }

        .fav-icon:hover {
            transform: scale(1.1);
        }

        .fav-icon.active {
            color: #ff2d2d;
            animation: pulse 0.5s ease;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.3); }
            100% { transform: scale(1); }
        }

        /* Smooth loading effect */
        .recipe-card {
            opacity: 0;
            animation: fadeIn 0.5s ease forwards;
        }

        @keyframes fadeIn {
            to { opacity: 1; }
        }
    </style>
</head>
<body>
    <%@ include file="BackButton.jsp" %>
    
    <header class="page-header">
        <h1 class="page-title animate__animated animate__fadeIn">
            <i class="fas fa-utensils"></i> All Recipes
        </h1>
    </header>
<div class="recipe-grid">
    <%
        // Check if the user is logged in through session or cookies
        String user = (String) session.getAttribute("username");
        
        // Check if the session exists; if not, check for cookies
        if (user == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("username")) {
                        user = cookie.getValue();
                        session.setAttribute("username", user); // Restore session from cookie
                        break;
                    }
                }
            }
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

            // Fetch all recipes
            String sql = "SELECT id, name, image FROM recipes ORDER BY id DESC";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int recipeId = rs.getInt("id");
                String recipeName = rs.getString("name");
                String recipeImage = rs.getString("image");

                // Check if the image exists, else use default image
                String imagePath = (recipeImage != null && !recipeImage.isEmpty()) ? "uploads/images/" + recipeImage : "uploads/images/default.jpg";

                // Check if the recipe is already in favorites
                String favQuery = "SELECT * FROM favorites WHERE recipe_id = ?";
                PreparedStatement favStmt = conn.prepareStatement(favQuery);
                favStmt.setInt(1, recipeId);
                ResultSet favRs = favStmt.executeQuery();
                boolean isFavorite = favRs.next();

                favRs.close();
                favStmt.close();
    %>
                <div class="recipe-card">
                    <i class="fa fa-heart fav-icon <%= isFavorite ? "active" : "" %>" 
                       onclick="toggleFavorite(this, <%= recipeId %>)"></i>

                    <a href="RecipeDetails.jsp?id=<%= recipeId %>">
                        <img src="<%= imagePath %>" 
                             alt="<%= recipeName %>" 
                             onerror="this.onerror=null; this.src='uploads/images/default.jpg';">
                        <h3><%= recipeName %></h3>
                    </a>
                </div>
    <%
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    %>
</div>

<%@ include file="Footer.jsp" %>

<script>
    function toggleFavorite(element, recipeId) {
        let isFavorite = element.classList.contains("active");
        element.classList.toggle("active");

        // Send AJAX request to update favorite status
        let xhr = new XMLHttpRequest();
        xhr.open("POST", "UpdateFavorite.jsp", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("recipeId=" + recipeId + "&action=" + (isFavorite ? "remove" : "add"));
    }
</script>

</body>
</html>
