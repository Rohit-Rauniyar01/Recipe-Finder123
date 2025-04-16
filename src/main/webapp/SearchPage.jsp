<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recipe Search</title>
    <link href="https://fonts.googleapis.com/css2?family=Capriola&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        :root {
            --primary: #007BFF;
            --primary-dark: #0056b3;
            --background: #f9f9f9;
            --card-bg: #fff;
            --text: #333;
            --shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        body {
            font-family: 'Capriola', sans-serif;
            background-color: var(--background);
            margin: 0;
            padding: 0;
            color: var(--text);
            min-height: 100vh;
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 30px 20px;
        }

        h1 {
            text-align: center;
            margin: 0 0 30px;
            font-size: 2.2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }

        .search-container {
            display: flex;
            justify-content: center;
            margin-bottom: 40px;
        }

        .search-box {
            width: 100%;
            max-width: 800px;
            display: flex;
            background: var(--card-bg);
            border-radius: 30px;
            box-shadow: var(--shadow);
            overflow: hidden;
            transition: var(--transition);
        }

        .search-box:focus-within {
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
            transform: translateY(-2px);
        }

        input[type="text"] {
            flex: 1;
            padding: 16px 25px;
            border: none;
            outline: none;
            font-size: 1.1rem;
            background: transparent;
        }

        button[type="submit"] {
            padding: 0 30px;
            border: none;
            background: var(--primary);
            color: white;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: var(--transition);
        }

        button[type="submit"]:hover {
            background: var(--primary-dark);
        }

        .section-title {
            text-align: center;
            font-size: 1.5rem;
            margin: 30px 0;
            position: relative;
        }

        .section-title:after {
            content: '';
            display: block;
            width: 80px;
            height: 3px;
            background: var(--primary);
            margin: 10px auto;
        }

        .recipe-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 30px;
            padding: 20px 0;
        }

        .recipe-card {
            background: var(--card-bg);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
        }

        .recipe-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }

        .recipe-image {
            width: 100%;
            height: 220px;
            object-fit: cover;
            transition: var(--transition);
        }

        .recipe-card:hover .recipe-image {
            transform: scale(1.03);
        }

        .recipe-info {
            padding: 20px;
            text-align: center;
        }

        .recipe-name {
            margin: 0 0 10px;
            font-size: 1.2rem;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .recipe-category {
            color: #666;
            font-size: 0.9rem;
            margin: 0;
        }

        .no-results {
            text-align: center;
            grid-column: 1 / -1;
            padding: 50px 0;
            font-size: 1.2rem;
            color: #666;
        }

        /* Loading animation */
        .loading {
            display: none;
            text-align: center;
            padding: 30px;
        }

        .spinner {
            width: 40px;
            height: 40px;
            border: 4px solid rgba(0, 0, 0, 0.1);
            border-radius: 50%;
            border-top-color: var(--primary);
            animation: spin 1s linear infinite;
            margin: 0 auto;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            h1 {
                font-size: 1.8rem;
            }
            
            .search-box {
                flex-direction: column;
                border-radius: 12px;
            }
            
            input[type="text"] {
                padding: 14px 20px;
            }
            
            button[type="submit"] {
                padding: 14px;
                width: 100%;
            }
            
            .recipe-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%@ include file = "BackButton.jsp" %>

<div class="container">
    <h1 class="animate__animated animate__fadeIn">🔍 Search Your Recipe</h1>

    <div class="search-container">
        <form method="post" class="search-box animate__animated animate__fadeIn animate__delay-1s">
            <input type="text" name="query" placeholder="Search recipes..." 
                   value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>"
                   aria-label="Search recipes">
            <button type="submit">Search</button>
        </form>
    </div>

    <div class="loading" id="loadingIndicator">
        <div class="spinner"></div>
    </div>

    <% if (request.getParameter("query") != null) { %>
        <h2 class="section-title animate__animated animate__fadeIn">Search Results</h2>
    <% } %>

    <div class="recipe-grid" id="recipeResults">
    <%
        String query = request.getParameter("query");
        boolean isSearchActive = query != null && !query.trim().isEmpty();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

            String sql = isSearchActive 
                ? "SELECT id, name, category, image FROM recipes WHERE LOWER(name) LIKE LOWER(?)"
                : "SELECT id, name, category, image FROM recipes";

            PreparedStatement stmt = conn.prepareStatement(sql);

            if (isSearchActive) {
                stmt.setString(1, "%" + query + "%");
            }

            ResultSet rs = stmt.executeQuery();
            boolean hasResults = false;
            int cardDelay = 0;

            while (rs.next()) {
                hasResults = true;
                int recipeId = rs.getInt("id");

                // Track search activity
                String searchQuery = "INSERT INTO search_activity (recipe_id, search_count) " +
                                    "VALUES (?, 1) ON DUPLICATE KEY UPDATE search_count = search_count + 1";
                PreparedStatement searchStmt = conn.prepareStatement(searchQuery);
                searchStmt.setInt(1, recipeId);
                searchStmt.executeUpdate();
                searchStmt.close();
    %>
                <a href="RecipeDetails.jsp?id=<%= recipeId %>" 
                   class="animate__animated animate__fadeInUp" 
                   style="animation-delay: <%= (cardDelay++ % 10) * 0.1 %>s">
                    <div class="recipe-card">
                        <img src="uploads/images/<%= rs.getString("image") %>" 
                             class="recipe-image"
                             alt="<%= rs.getString("name") %>" 
                             onerror="this.onerror=null; this.src='uploads/images/default.jpg';">
                        <div class="recipe-info">
                            <h3 class="recipe-name"><%= rs.getString("name") %></h3>
                            <p class="recipe-category"><%= rs.getString("category") %></p>
                        </div>
                    </div>
                </a>
    <%
            }

            if (!hasResults && isSearchActive) {
    %>
                <div class="no-results animate__animated animate__fadeIn">
                    No recipes found for "<%= query %>"
                </div>
    <%
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
    %>
            <div class="no-results animate__animated animate__fadeIn">
                Error loading recipes: <%= e.getMessage() %>
            </div>
    <%
        }
    %>
    </div>
</div>

<%@ include file="Footer.jsp" %>

<script>
    // Show loading indicator when form is submitted
    document.querySelector('form').addEventListener('submit', function() {
        document.getElementById('loadingIndicator').style.display = 'block';
        document.getElementById('recipeResults').style.opacity = '0.5';
    });

    // Animate cards as they come into view
    document.addEventListener("DOMContentLoaded", function() {
        const animateOnScroll = function() {
            const cards = document.querySelectorAll('.animate__animated');
            
            cards.forEach(card => {
                const cardPosition = card.getBoundingClientRect().top;
                const windowHeight = window.innerHeight;
                
                if (cardPosition < windowHeight - 100) {
                    card.style.opacity = 1;
                }
            });
        };
        
        // Run once on load and then on scroll
        animateOnScroll();
        window.addEventListener('scroll', animateOnScroll);
    });
</script>

</body>
</html>