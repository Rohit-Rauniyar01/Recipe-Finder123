<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    // Redirect if user is not logged in
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if user not authenticated
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Favorite Recipes</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Font & Styling Libraries -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Capriola&family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #ff5e57;
            --secondary-color: #ff9a44;
            --text-color: #333;
            --light-text: #666;
            --bg-color: #f8f9fa;
            --card-bg: #ffffff;
            --shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            --hover-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }
        
        body {
            font-family: 'Poppins', 'Capriola', sans-serif;
            background-color: var(--bg-color);
            margin: 0;
            padding: 0;
            color: var(--text-color);
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        header {
            text-align: center;
            position: relative;
        }
        
        h1 {
            color: var(--primary-color);
            margin: 0;
            font-size: 2.5rem;
            font-weight: 600;
            position: relative;
            display: inline-block;
        }
        
        h1::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            border-radius: 2px;
        }
        
        .recipe-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            padding: 30px 0;
        }
        
        .recipe-card {
            background: var(--card-bg);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow);
            transition: var(--transition);
            position: relative;
        }
        
        .recipe-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--hover-shadow);
        }
        
        .recipe-image {
            width: 100%;
            height: 200px;
            position: relative;
            overflow: hidden;
        }
        
        .recipe-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .recipe-card:hover .recipe-image img {
            transform: scale(1.05);
        }
        
        .recipe-info {
            padding: 20px;
            position: relative;
        }
        
        .recipe-info h3 {
            margin: 0 0 10px;
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-color);
        }
        
        .favorite-icon {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255, 255, 255, 0.9);
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            font-size: 1.2rem;
            cursor: pointer;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            transition: var(--transition);
            z-index: 2;
        }
        
        .favorite-icon:hover {
            transform: scale(1.1);
            color: #ff2e2e;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .empty-state i {
            font-size: 4rem;
            color: var(--primary-color);
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        .empty-state h2 {
            color: var(--text-color);
            margin-bottom: 15px;
        }
        
        .empty-state p {
            color: var(--light-text);
            font-size: 1.1rem;
            margin-bottom: 25px;
        }
        
        .explore-btn {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            box-shadow: 0 4px 15px rgba(255, 94, 87, 0.3);
        }
        
        .explore-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 94, 87, 0.4);
        }
        
        @media (max-width: 768px) {
            .recipe-grid {
                grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
                gap: 20px;
            }
            
            h1 {
                font-size: 2rem;
            }
        }
        
        @media (max-width: 480px) {
            .recipe-grid {
                grid-template-columns: 1fr;
            }
            
            .recipe-image {
                height: 180px;
            }
        }
    </style>
</head>
<body>
<%@ include file = "BackButton.jsp" %>

<div class="container">
    <header>
        <h1><i class="fas fa-heart" style="margin-right: 10px;"></i>Favorite Recipes</h1>
    </header>

    <div class="recipe-grid">
        <% boolean hasFavorites = false; %>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

                String sql = "SELECT r.id, r.name, r.image " +
                             "FROM favorites f " +
                             "JOIN recipes r ON f.recipe_id = r.id " +
                             "WHERE f.user_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId); // Use session-based user ID

                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    hasFavorites = true;
        %>
            <div class="recipe-card">
                <div class="favorite-icon" data-recipe-id="<%= rs.getInt("id") %>">
                    <i class="fas fa-heart"></i>
                </div>
                <a href="RecipeDetails.jsp?id=<%= rs.getInt("id") %>" style="text-decoration: none; color: inherit;">
                    <div class="recipe-image">
                        <img src="uploads/images/<%= rs.getString("image") %>"
                             alt="<%= rs.getString("name") %>"
                             onerror="this.onerror=null; this.src='uploads/images/default.jpg';">
                    </div>
                    <div class="recipe-info">
                        <h3><%= rs.getString("name") %></h3>
                    </div>
                </a>
            </div>
        <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:var(--primary-color); text-align:center; padding:20px;'>Error loading favorites. Please try again later.</p>");
                e.printStackTrace();
            }
        %>
    </div>

    <% if (!hasFavorites) { %>
        <div class="empty-state">
            <i class="far fa-heart"></i>
            <h2>No favorites yet</h2>
            <p>You haven't saved any recipes to your favorites. Explore our collection and save your favorites!</p>
            <button class="explore-btn" onclick="window.location.href='RecipePage.jsp'">Explore Recipes</button>
        </div>
    <% } %>
</div>

<script>
    // Smooth delete animation and AJAX call for removing favorites
    document.querySelectorAll('.favorite-icon').forEach(icon => {
        icon.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();

            const recipeId = this.getAttribute('data-recipe-id');
            const heart = this.querySelector('i');

            heart.style.transform = 'scale(1.3)';

            fetch('RemoveFavoriteServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `recipeId=${recipeId}`
            })
            .then(response => {
                if (response.ok) {
                    this.closest('.recipe-card').style.opacity = '0';
                    setTimeout(() => {
                        this.closest('.recipe-card').remove();
                        if (document.querySelectorAll('.recipe-card').length === 0) {
                            location.reload(); // Reload to show empty state
                        }
                    }, 300);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                heart.style.transform = 'scale(1)';
            });

            setTimeout(() => {
                heart.style.transform = 'scale(1)';
            }, 300);
        });
    });
</script>

</body>
</html>
