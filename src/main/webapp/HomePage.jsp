<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home Page</title>
<link href="https://fonts.googleapis.com/css2?family=Capriola&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">

<style>
    /* Global Styles */
    :root {
        --primary-color: #e40046;
        --secondary-color: #0BA5A5;
        --accent-color: #f50057;
        --light-bg: #F5F5F5;
        --white: #ffffff;
        --dark-text: #333333;
        --transition: all 0.3s ease;
    }
    
    * {
        box-sizing: border-box;
    }
    
    body {
        font-family: 'Capriola', sans-serif;
        margin: 0;
        padding: 0;
        background-color: var(--light-bg);
        color: var(--dark-text);
        line-height: 1.6;
    }

    h1, h2, h3, p {
        text-align: center;
        color: var(--dark-text);
        text-decoration: none;
        margin: 0.5em 0;
    }

    a {
        text-decoration: none;
        color: inherit;
        transition: var(--transition);
    }

    /* Navigation Bar */
    header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background-color: var(--primary-color);
        padding: 10px 5%;
        color: var(--white);
        position: sticky;
        top: 0;
        z-index: 1000;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }

    .logo img {
        width: 50px;
        height: auto;
        transition: var(--transition);
    }

    .logo img:hover {
        transform: scale(1.05);
    }

    nav ul {
        display: flex;
        list-style: none;
        margin: 0;
        padding: 0;
        align-items: center;
    }

    nav ul li {
        margin: 0 15px;
        position: relative;
    }

    nav ul li a {
        color: var(--white);
        font-weight: bold;
        padding: 5px 0;
        position: relative;
    }

    nav ul li a:after {
        content: '';
        position: absolute;
        width: 0;
        height: 2px;
        bottom: 0;
        left: 0;
        background-color: var(--white);
        transition: var(--transition);
    }

    nav ul li a:hover:after {
        width: 100%;
    }

    .auth-buttons {
        display: flex;
        gap: 15px;
    }

    .auth-buttons a {
        background-color: var(--white);
        color: var(--primary-color);
        padding: 8px 15px;
        border-radius: 5px;
        font-weight: bold;
        transition: var(--transition);
    }

    .auth-buttons a:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }

    /* Profile Section */
    .profile {
        position: relative;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: rgba(255, 255, 255, 0.2);
        padding: 10px;
        border-radius: 50%;
        transition: var(--transition);
    }

    .profile:hover {
        background-color: rgba(255, 255, 255, 0.3);
    }

    .profile-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 20px;
        height: 20px;
        border-radius: 50%;
        background-color: rgba(255, 255, 255, 0.3);
        border: 2px solid var(--white);
    }

    /* Dropdown */
    .dropdown {
        display: none;
        position: absolute;
        top: 50px;
        right: 0;
        background: var(--white);
        border-radius: 5px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
        padding: 10px 0;
        width: 180px;
        z-index: 1000;
        opacity: 0;
        transform: translateY(-10px);
        transition: all 0.3s ease;
    }

    .dropdown.show {
        display: block;
        opacity: 1;
        transform: translateY(0);
    }

    .dropdown a {
        display: block;
        padding: 10px 15px;
        color: var(--dark-text);
        font-size: 16px;
        transition: var(--transition);
    }

    .dropdown a:hover {
        background: rgba(0,0,0,0.05);
        color: var(--primary-color);
        padding-left: 20px;
    }

    /* Hero Section */
    .hero {
        background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)), url('bg.jpg');
        background-size: cover;
        height: 73vh;
        background-position: center;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
    }

    .hero::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 0;
        width: 100%;
        height: 50px;
        background: linear-gradient(to bottom, transparent, var(--light-bg));
    }

    .hero-container {
        background-color: rgba(243, 69, 108, 0.9);
        width: 60%;
        padding: 30px;
        border-radius: 10px;
        margin: 20px;
        transform: translateY(20px);
        animation: fadeInUp 1s ease forwards;
    }

    .hero-container h1 {
        color: var(--white);
        font-size: 2.5rem;
        text-align: start;
        margin-bottom: 15px;
    }

    .hero-container p {
        color: var(--white);
        font-size: 1.2rem;
        text-align: start;
        line-height: 1.6;
    }

    /* Content Sections */
    .section-title {
        text-align: center;
        margin: 40px 0 20px;
        position: relative;
    }

    .section-title:after {
        content: '';
        display: block;
        width: 80px;
        height: 3px;
        background: var(--primary-color);
        margin: 10px auto;
    }

    .section-subtitle {
        color: #666;
        margin-bottom: 30px;
    }

    .inspiration, .trending {
        padding: 30px 5%;
    }

    /* Cards Container */
    .card-container {
        display: flex;
        justify-content: center;
        gap: 30px;
        padding: 20px 0;
        flex-wrap: wrap;
    }

    /* Card Styles */
    .card {
        width: 350px;
        border-radius: 10px;
        overflow: hidden;
        background: var(--white);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        transition: var(--transition);
        margin-bottom: 20px;
    }

    .card:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.15);
    }

    .card-img {
        width: 100%;
        height: 250px;
        object-fit: cover;
        display: block;
    }

    .card-body {
        padding: 15px;
    }

    .card-title {
        font-weight: bold;
        margin: 10px 0;
        font-size: 1.2rem;
    }

    /* Buttons */
    .btn {
        display: inline-block;
        background-color: var(--secondary-color);
        color: var(--white);
        padding: 12px 28px;
        border: none;
        border-radius: 5px;
        font-size: 1rem;
        cursor: pointer;
        min-width: 200px;
        text-align: center;
        transition: var(--transition);
        margin: 10px 0;
        font-weight: bold;
    }

    .btn:hover {
        background-color: #0a8f8f;
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    }

    .btn-block {
        display: block;
        width: 100%;
    }

    /* More Link */
    .more-link {
        display: inline-block;
        color: var(--primary-color);
        font-weight: bold;
        margin: 20px 0;
        transition: var(--transition);
    }

    .more-link:hover {
        color: var(--accent-color);
        transform: translateX(5px);
    }

    .more-link i {
        margin-left: 5px;
    }

    /* Responsive Adjustments */
    @media (max-width: 992px) {
        .hero-container {
            width: 80%;
        }
        
        .card {
            width: 300px;
        }
    }

    @media (max-width: 768px) {
        header {
            flex-direction: column;
            padding: 15px;
        }
        
        nav ul {
            margin-top: 15px;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        nav ul li {
            margin: 5px 10px;
        }
        
        .hero-container {
            width: 90%;
            padding: 20px;
        }
        
        .hero-container h1 {
            font-size: 2rem;
        }
        
        .hero-container p {
            font-size: 1rem;
        }
    }

    @media (max-width: 576px) {
        .hero {
            height: 50vh;
        }
        
        .card {
            width: 100%;
            max-width: 350px;
        }
    }

    /* Animations */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .animate-delay-1 {
        animation-delay: 0.2s;
    }

    .animate-delay-2 {
        animation-delay: 0.4s;
    }

    .animate-delay-3 {
        animation-delay: 0.6s;
    }
</style>
</head>
<body>

<%
    // Check if user is logged in
    String user = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    
    // Check cookies if session is null
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
    
    // Redirect to login page if user is not logged in
    if (user == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<header>
    <div class="logo">
        <img src="logo.png" alt="Recipe Finder Logo">
    </div>
    <nav>
        <ul>
            <li><a href="HomePage.jsp">Home</a></li>
            <li><a href="RecipePage.jsp">Recipes</a></li>
            <li><a href="Trending.jsp">Trending</a></li>
            <li><a href="SearchPage.jsp">Search</a></li>
            <% if (user != null) { %>
                <li><a href="Favorites.jsp">Favorite</a></li>
            <% } %>

            <% if (user == null) { %>
                <!-- If No User Logged In -->
                <li class="auth-buttons">
                    <a href="Signup.jsp" class="animate__animated animate__fadeIn">Sign Up</a>
                    <a href="Login.jsp" class="animate__animated animate__fadeIn">Sign In</a>
                </li>
            <% } else { %>
                <!-- If User/Admin Logged In -->
                <li class="profile">
                    <div id="profileIcon" class="profile-icon">
                        <i class="fa-regular fa-user" alt="Profile Icon"></i> 
                    </div>
                    <div id="profileDropdown" class="dropdown">
                        <% if ("admin".equals(role)) { %>
                            <a href="AdminPanal.jsp"><i class="fas fa-cog"></i> Admin Panel</a>
                        <% } %>
                        <a href="Profile.jsp"><i class="fas fa-user"></i> Manage Profile</a>
                        <a href="LogoutServlet"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </li>
            <% } %>
        </ul>
    </nav>
</header>

<!-- Hero Section -->
<section class="hero">
    <div class="hero-container animate__animated animate__fadeIn">
        <h1>What can I make with.....</h1>
        <p>Our recipe finder tool will show you all the things you can make, 
            so none of your food goes to waste, with only a few added ingredients needed.</p>
    </div>
</section>

<!-- Inspiration Section -->
<section class="inspiration">
    <h2 class="section-title">Looking for inspiration?</h2>
    <p class="section-subtitle">To make something new...</p>
    
    <div class="card-container">
        <div class="card animate__animated animate__fadeInUp animate-delay-1">
            <img src="https://thepeasantsdaughter.net/wp-content/uploads/2024/08/hungarian-goulash-gulyas-recipe.jpg" alt="Vegetarian Recipes" class="card-img">
            <div class="card-body">
                <button class="btn btn-block"><a href="RecipeServlet?category=Vegetarian">Vegetarian Recipes</a></button>
            </div>
        </div>
        
        <div class="card animate__animated animate__fadeInUp animate-delay-2">
            <img src="https://hips.hearstapps.com/hmg-prod/images/harvest-bowls-index-66b3f14d6d5d4.jpg?crop=0.502xw:1.00xh;0,0&resize=640:*" alt="Healthy Recipes" class="card-img">
            <div class="card-body">
                <button class="btn btn-block"><a href="RecipeServlet?category=Healthy">Healthy Recipes</a></button>
            </div>
        </div>
        
        <div class="card animate__animated animate__fadeInUp animate-delay-3">
            <img src="https://www.pamelasproducts.com/cdn/shop/files/PanPancakeMix.jpg?v=1694125550" alt="Baking Recipes" class="card-img">
            <div class="card-body">
                <button class="btn btn-block"><a href="RecipeServlet?category=Baking">Baking Recipes</a></button>
            </div>
        </div>
    </div>
    
    <div style="text-align: center;">
        <a href="CategoryPage.jsp" class="more-link">Explore more categories <i class="fas fa-arrow-right"></i></a>
    </div>
</section>

<!-- Trending Recipes Section -->
<section class="trending">
    <h2 class="section-title">Trending Recipes</h2>
    
    <div class="card-container">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");

                // Fetch top 3 trending recipes based on search counts
                String sql = "SELECT r.id, r.name, r.image FROM recipes r " +
                              "JOIN search_activity sa ON r.id = sa.recipe_id " +
                              "ORDER BY sa.search_count DESC LIMIT 3";
                PreparedStatement stmt = conn.prepareStatement(sql);
                ResultSet rs = stmt.executeQuery();

                int delay = 1;
                while (rs.next()) {
                    int recipeId = rs.getInt("id");
                    String recipeName = rs.getString("name");
                    String recipeImage = rs.getString("image");

                    // Check if the image exists, else use default image
                    String imagePath = (recipeImage != null && !recipeImage.isEmpty()) ? "uploads/images/" + recipeImage : "uploads/images/default.jpg";
        %>
                    <div class="card animate__animated animate__fadeInUp animate-delay-<%= delay %>">
                        <img src="<%= imagePath %>" alt="<%= recipeName %>" class="card-img">
                        <div class="card-body">
                            <h3 class="card-title"><%= recipeName %></h3>
                            <button class="btn btn-block"><a href="RecipeDetails.jsp?id=<%= recipeId %>">View Recipe</a></button>
                        </div>
                    </div>
        <%
                    delay++;
                }

                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p style='color:red; text-align:center;'>Error loading trending recipes: " + e.getMessage() + "</p>");
            }
        %>
    </div>
    
    <div style="text-align: center;">
        <a href="Trending.jsp" class="more-link">See all trending recipes <i class="fas fa-arrow-right"></i></a>
    </div>
</section>

<!-- JavaScript -->
<script>
document.addEventListener("DOMContentLoaded", function() {
    // Profile dropdown toggle
    const profileIcon = document.getElementById("profileIcon");
    const dropdown = document.getElementById("profileDropdown");
    
    profileIcon.addEventListener("click", function(e) {
        e.stopPropagation();
        dropdown.classList.toggle("show");
    });
    
    // Close dropdown when clicking outside
    document.addEventListener("click", function() {
        dropdown.classList.remove("show");
    });
    
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });
    
    // Animate elements when they come into view
    const animateOnScroll = function() {
        const elements = document.querySelectorAll('.animate__animated');
        
        elements.forEach(element => {
            const elementPosition = element.getBoundingClientRect().top;
            const windowHeight = window.innerHeight;
            
            if (elementPosition < windowHeight - 100) {
                const animationClass = element.classList[1];
                element.classList.add(animationClass);
            }
        });
    };
    
    // Run once on load and then on scroll
    animateOnScroll();
    window.addEventListener('scroll', animateOnScroll);
});
</script>

<%@ include file = "Footer.jsp" %>
</body>
</html>