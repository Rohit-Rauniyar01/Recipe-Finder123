<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>RecipeDetails</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    /* General Styles */
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f4;
        margin: 0;
        padding: 0;
        line-height: 1.6;
    }

    .back-arrow {
        text-align: left;
        padding: 20px;
        font-size: 22px;
    }

    .back-arrow a {
        text-decoration: none;
        color: black;
    }

    header {
        text-align: center;
        padding: 0px;
    }

    header h1 {
        margin: 0;
        font-size: 2.5em;
    }

    .tags {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 10px;
    }

    .tags span {
        background-color: #ffcdd2;
        color: #d32f2f;
        padding: 5px 10px;
        border-radius: 15px;
        font-size: 0.9em;
    }

    /* Image Section */
    .image-section {
        text-align: center;
        margin: 20px 0;
    }

    .recipe-image {
        width: 300px; /* Updated to 45px */
        height: 300px; /* Updated to 45px */
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    /* Ingredients Section */
    .ingredients-section {
        margin: 20px;
    }

    .ingredients-section h2 {
        padding-bottom: 5px;
        margin-left: 60px;
    }

    .ingredient-container {
    	gap: 5px;
        display: flex;
        flex-direction: column;
    }

    .ingredient-item {
        display: flex;
        justify-content: space-between;
        background-color: transparent;
        padding: 10px;
        border: 1px solid black;
        border-radius: 5px;
        margin-left: 230px;
        margin-right: 260px;
    }

    .ingredient-name {
        font-weight: bold;
    }

    .ingredient-quantity {
        color: #555;
    }

    /* Instructions Section */
    .instructions-section {
        margin: 20px;
    }

    .instructions-section h2 {
        color: black;
        padding-bottom: 5px;
        margin-left: 60px;
    }

    .instruction-list {
        padding-left: 0;
    }

    .instruction-item {
        background-color: transparent;
        padding: 10px;
        border: 1px solid black;
        border-radius: 5px;
        margin-left: 230px;
        margin-right: 260px;
        margin-bottom: 10px;
    }

    .video-section {
        text-align: center;
        margin: 20px 0;
    }

    .watch-video-button {
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: white;
        background-color: #007BFF;
        border: none;
        border-radius: 5px;
        text-decoration: none;
        transition: background-color 0.3s ease;
    }

    .watch-video-button:hover {
        background-color: #0056b3;
    }
</style>

</head>
<body>
<%@ include file = "BackButton.jsp" %>



<%
    String recipeId = request.getParameter("id");

    if (recipeId != null && !recipeId.isEmpty()) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

            String query = "SELECT * FROM recipes WHERE id = ?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, recipeId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
%>

    <!-- Header Section -->
    <header>
        <h1><%= rs.getString("name") %></h1>
        <p><%= rs.getString("category") %></p>
    </header>

    <!-- Image Section -->
    <section class="image-section">
        <img class="recipe-image" src="uploads/images/<%= rs.getString("image") %>" 
                            alt="<%= rs.getString("name") %>" 
                            onerror="this.onerror=null; this.src='uploads/images/default.jpg';">
    </section>

    <!-- Ingredients Section -->
    <section class="ingredients-section">
        <h2>Ingredients need to make it</h2>
        <div class="ingredient-container">
            <% for (String ingredient : rs.getString("ingredients").split("\\n")) { %>
                <div class="ingredient-item">
                    <span class="ingredient-name"><%= ingredient %></span>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Instructions Section -->
    <section class="instructions-section">
        <h2>Instructions</h2>
        <div class="instruction-list">
            <% for (String instruction : rs.getString("instructions").split("\\n")) { %>
                <div class="instruction-item">
                    <%= instruction %>
                </div>
            <% } %>
        </div>
    </section>

    <!-- Video Section -->
    <section class="video-section">
        <% String videoUrl = rs.getString("youtubeLink"); %>
        <% if (videoUrl != null && !videoUrl.trim().isEmpty()) { %>
            <a href="<%= videoUrl %>" target="_blank" class="watch-video-button">Watch Recipe Video</a>
        <% } else { %>
            <p>No video available for this recipe.</p>
        <% } %>
    </section>

<%
            } else {
                out.println("<h2>Recipe not found!</h2>");
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h2>Error loading recipe details.</h2>");
        }
    } else {
        out.println("<h2>Invalid recipe ID!</h2>");
    }
%>

<%@ include file="Footer.jsp" %>

</body>
</html>
