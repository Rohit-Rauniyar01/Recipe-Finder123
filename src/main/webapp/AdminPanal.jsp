<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || !"admin".equals(adminSession.getAttribute("role"))) {
        response.sendRedirect("Login.jsp?error=Unauthorized access");
        return;
    }

    // Database connection
    String url = "jdbc:mysql://localhost:3306/RecipeFinder";
    String username = "root";
    String password = "root";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int vegetarianCount = 0;
    int nonVegetarianCount = 0;
    int bakingCount = 0;
    int partyCount = 0;
    int saladCount = 0;
    int dessertsCount = 0;
    int soupCount = 0;
    int healthyCount = 0;
    int sweetsCount = 0;
    int userCount = 0;
    int totalRecipes = 0;
    int missingRecipesCount = 0;
    String missingRecipesStatus = "stable";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);

        // Get recipe counts by category
        String query = "SELECT category, COUNT(*) AS count FROM Recipes GROUP BY category";
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();

        while (rs.next()) {
            String category = rs.getString("category");
            int count = rs.getInt("count");
            totalRecipes += count;
            switch (category) {
                case "Vegetarian": vegetarianCount = count; break;
                case "Non-Vegetarian": nonVegetarianCount = count; break;
                case "Baking": bakingCount = count; break;
                case "Party": partyCount = count; break;
                case "Salad": saladCount = count; break;
                case "Desserts": dessertsCount = count; break;
                case "Soup": soupCount = count; break;
                case "Healthy": healthyCount = count; break;
                case "Sweets": sweetsCount = count; break;
            }
        }

        // Get user count
        String userQuery = "SELECT COUNT(*) AS userCount FROM Users";
        ps = conn.prepareStatement(userQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            userCount = rs.getInt("userCount");
        }

        // Get missing recipes count (recipes with missing ingredients)
        String missingQuery = "SELECT COUNT(*) AS missingCount FROM Recipes WHERE ingredients IS NULL OR ingredients = '' OR instructions IS NULL OR instructions = ''";
        ps = conn.prepareStatement(missingQuery);
        rs = ps.executeQuery();
        if (rs.next()) {
            missingRecipesCount = rs.getInt("missingCount");
        }

        // Determine status
        if (missingRecipesCount > 5) {
            missingRecipesStatus = "increase";
        } else if (missingRecipesCount > 0) {
            missingRecipesStatus = "decrease";
        } else {
            missingRecipesStatus = "stable";
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard | RecipeFinder</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #ff4757;
            --secondary-color: #1e90ff;
            --accent-color: #2ed573;
            --dark-color: #2f3542;
            --light-color: #f1f2f6;
            --sidebar-width: 280px;
            --transition-speed: 0.3s;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8fafc;
            color: #333;
            line-height: 1.6;
        }

        .container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            width: var(--sidebar-width);
            background: linear-gradient(135deg, var(--dark-color), #1a1a1a);
            color: white;
            padding: 2rem 1.5rem;
            height: 100vh;
            position: fixed;
            display: flex;
            flex-direction: column;
            box-shadow: 4px 0 15px rgba(0, 0, 0, 0.1);
            z-index: 10;
            transition: transform var(--transition-speed) ease;
        }

        .sidebar-header {
            margin-bottom: 2.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h2 {
            font-size: 1.5rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .sidebar-header h2 i {
            color: var(--primary-color);
        }

        .nav-menu {
            flex-grow: 1;
        }

        .nav-item {
            margin-bottom: 0.5rem;
            border-radius: 8px;
            overflow: hidden;
            transition: all var(--transition-speed) ease;
        }

        .nav-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .nav-item.active {
            background-color: var(--primary-color);
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 0.85rem 1rem;
            color: white;
            text-decoration: none;
            font-size: 1rem;
            font-weight: 500;
            gap: 1rem;
        }

        .nav-link i {
            width: 24px;
            text-align: center;
            font-size: 1.1rem;
        }

        .logout-btn {
            margin-top: auto;
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 0.85rem 1rem;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            transition: all var(--transition-speed) ease;
        }

        .logout-btn:hover {
            background-color: #ff6b81;
            transform: translateY(-2px);
        }

        /* Main Content Styles */
        .main-content {
            flex: 1;
            margin-left: var(--sidebar-width);
            padding: 2rem;
            transition: margin-left var(--transition-speed) ease;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .page-title h1 {
            font-size: 2rem;
            font-weight: 600;
            color: var(--dark-color);
        }

        .page-title p {
            color: #666;
            font-size: 0.9rem;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        /* Dashboard Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: all var(--transition-speed) ease;
            cursor: pointer;
            border-left: 4px solid var(--primary-color);
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-card.blue {
            border-left-color: var(--secondary-color);
        }

        .stat-card.green {
            border-left-color: var(--accent-color);
        }

        .stat-card.purple {
            border-left-color: #9c88ff;
        }

        .stat-card.orange {
            border-left-color: #ffa502;
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.25rem;
        }

        .stat-icon.primary {
            background-color: var(--primary-color);
        }

        .stat-icon.secondary {
            background-color: var(--secondary-color);
        }

        .stat-icon.accent {
            background-color: var(--accent-color);
        }

        .stat-icon.purple {
            background-color: #9c88ff;
        }

        .stat-icon.orange {
            background-color: #ffa502;
        }

        .stat-title {
            font-size: 0.9rem;
            color: #666;
            font-weight: 500;
        }

        .stat-value {
            font-size: 1.75rem;
            font-weight: 600;
            margin: 0.5rem 0;
            color: var(--dark-color);
        }

        .stat-change {
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .stat-change.positive {
            color: var(--accent-color);
        }

        .stat-change.negative {
            color: var(--primary-color);
        }

        /* Category Cards */
        .categories-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            color: var(--dark-color);
        }

        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 1.5rem;
        }

        .category-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: all var(--transition-speed) ease;
            cursor: pointer;
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        .category-icon {
            width: 60px;
            height: 60px;
            margin: 0 auto 1rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }

        .category-icon.vegetarian {
            background-color: #2ecc71;
        }

        .category-icon.non-veg {
            background-color: #e74c3c;
        }

        .category-icon.baking {
            background-color: #f39c12;
        }

        .category-icon.party {
            background-color: #9b59b6;
        }

        .category-icon.salad {
            background-color: #1abc9c;
        }

        .category-icon.desserts {
            background-color: #e84393;
        }

        .category-icon.soup {
            background-color: #0984e3;
        }

        .category-icon.healthy {
            background-color: #00b894;
        }

        .category-icon.sweets {
            background-color: #fd79a8;
        }

        .category-icon.search {
            background-color: #6c5ce7;
        }

        .category-name {
            font-size: 1.1rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: var(--dark-color);
        }

        .category-count {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--primary-color);
        }

        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            z-index: 100;
            opacity: 0;
            transition: opacity var(--transition-speed) ease;
            pointer-events: none;
        }

        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 1;
            pointer-events: auto;
        }

        .modal-content {
            background-color: white;
            border-radius: 12px;
            width: 90%;
            max-width: 800px;
            max-height: 80vh;
            overflow-y: auto;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            transform: translateY(-20px);
            transition: transform var(--transition-speed) ease;
            position: relative;
        }

        .modal.show .modal-content {
            transform: translateY(0);
        }

        .modal-header {
            padding: 1.5rem;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-color);
        }

        .close-modal {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #666;
            transition: color var(--transition-speed) ease;
        }

        .close-modal:hover {
            color: var(--primary-color);
        }

        .modal-body {
            padding: 1.5rem;
        }

        /* Recipe Table Styles */
        .recipe-table {
            width: 100%;
            border-collapse: collapse;
        }
        .recipe-table th, .recipe-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .recipe-table th {
            background-color: #f8f9fa;
            font-weight: 600;
        }
        .edit-btn {
            color: #1e90ff;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .edit-btn:hover {
            text-decoration: underline;
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .sidebar {
                transform: translateX(-100%);
            }
            .sidebar.show {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
            }
            .menu-toggle {
                display: block;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .fade-in {
            animation: fadeIn 0.5s ease forwards;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar" id="sidebar">
            <div class="sidebar-header">
                <h2><i class="fas fa-utensils"></i> RecipeFinder</h2>
            </div>
            <nav class="nav-menu">
                <div class="nav-item active">
                    <a href="AdminPanal.jsp" class="nav-link">
                        <i class="fas fa-tachometer-alt"></i>
                        <span>Dashboard</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="AddRecipe.jsp" class="nav-link">
                        <i class="fas fa-plus-circle"></i>
                        <span>Add Recipes</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="RecipeList.jsp" class="nav-link">
                        <i class="fas fa-list-ul"></i>
                        <span>All Recipes</span>
                    </a>
                </div>
                <div class="nav-item">
                    <a href="UserManagement.jsp" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>User Management</span>
                    </a>
                </div>
            </nav>
            <form action="LogoutServlet" method="post">
                <button type="submit" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Log Out</span>
                </button>
            </form>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="header">
                <div class="page-title">
                    <h1>Admin Dashboard</h1>
                    <p>Welcome back! Here's what's happening with your recipes today.</p>
                </div>
                <div class="user-profile">
                    <div class="user-avatar">A</div>
                </div>
            </div>

            <!-- Stats Overview -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div>
                            <div class="stat-title">Total Recipes</div>
                            <div class="stat-value"><%= totalRecipes %></div>
                        </div>
                        <div class="stat-icon primary">
                            <i class="fas fa-utensils"></i>
                        </div>
                    </div>
                </div>
                <div class="stat-card blue">
                    <div class="stat-header">
                        <div>
                            <div class="stat-title">Total Users</div>
                            <div class="stat-value"><%= userCount %></div>
                        </div>
                        <div class="stat-icon secondary">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                </div>
               
            </div>

            <!-- Recipe Categories -->
            <h2 class="categories-title">Recipe Categories</h2>
            <div class="categories-grid">
                <div class="category-card" onclick="showCategoryRecipes('Vegetarian')">
                    <div class="category-icon vegetarian">
                        <i class="fas fa-carrot"></i>
                    </div>
                    <h3 class="category-name">Vegetarian</h3>
                    <div class="category-count"><%= vegetarianCount %></div>
                </div>
                <div class="category-card" onclick="showCategoryRecipes('Non-Vegetarian')">
                    <div class="category-icon non-veg">
                        <i class="fas fa-drumstick-bite"></i>
                    </div>
                    <h3 class="category-name">Non-Vegetarian</h3>
                    <div class="category-count"><%= nonVegetarianCount %></div>
                </div>
                <div class="category-card" onclick="showCategoryRecipes('Baking')">
                    <div class="category-icon baking">
                        <i class="fas fa-bread-slice"></i>
                    </div>
                    <h3 class="category-name">Baking</h3>
                    <div class="category-count"><%= bakingCount %></div>
                </div>
                <div class="category-card" onclick="showCategoryRecipes('Party')">
                    <div class="category-icon party">
                        <i class="fas fa-glass-cheers"></i>
                    </div>
                    <h3 class="category-name">Party</h3>
                    <div class="category-count"><%= partyCount %></div>
                </div>
                <div class="category-card" onclick="showCategoryRecipes('Salad')">
                    <div class="category-icon salad">
                        <i class="fas fa-leaf"></i>
                    </div>
                    <h3 class="category-name">Salad</h3>
                    <div class="category-count"><%= saladCount %></div>
                </div>
                <div class="category-card" onclick="showCategoryRecipes('Desserts')">
                    <div class="category-icon desserts">
                        <i class="fas fa-ice-cream"></i>
                    </div>
                    <h3 class="category-name">Desserts</h3>
                    <div class="category-count"><%= dessertsCount %></div>
                </div>
                <div class="category-card" onclick="showCategoryRecipes('Soup')">
                    <div class="category-icon soup">
                        <i class="fas fa-hotdog"></i>
                    </div>
                    <h3 class="category-name">Soup</h3>
                    <div class="category-count"><%= soupCount %></div>
                </div>
                <div class="category-card" onclick="showCategoryRecipes('Healthy')">
                    <div class="category-icon healthy">
                        <i class="fas fa-apple-alt"></i>
                    </div>
                    <h3 class="category-name">Healthy</h3>
                    <div class="category-count"><%= healthyCount %></div>
                </div>
                <div class="category-card" onclick="showCategoryRecipes('Sweets')">
                    <div class="category-icon sweets">
                        <i class="fas fa-cookie"></i>
                    </div>
                    <h3 class="category-name">Sweets</h3>
                    <div class="category-count"><%= sweetsCount %></div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for Displaying Recipes -->
    <div class="modal" id="recipesModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">Recipes</h3>
                <button class="close-modal" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body" id="modalContent">
                <!-- Content will be loaded here -->
            </div>
        </div>
    </div>

    <script>
        // Show recipes for a specific category
        function showCategoryRecipes(category) {
            fetch('GetRecipesByCategory.jsp?category=' + encodeURIComponent(category))
                .then(response => response.text())
                .then(data => {
                    document.getElementById('modalTitle').textContent = category + ' Recipes';
                    document.getElementById('modalContent').innerHTML = data;
                    document.getElementById('recipesModal').classList.add('show');
                    document.body.style.overflow = 'hidden';
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('modalContent').innerHTML = 
                        '<p>Error loading recipes. Please try again.</p>';
                });
        }

        // Show missing recipes
        function showMissingRecipes() {
            fetch('GetMissingRecipes.jsp')
                .then(response => response.text())
                .then(data => {
                    document.getElementById('modalTitle').textContent = 'Recipes with Missing Information';
                    document.getElementById('modalContent').innerHTML = data;
                    document.getElementById('recipesModal').classList.add('show');
                    document.body.style.overflow = 'hidden';
                })
                .catch(error => {
                    console.error('Error:', error);
                    document.getElementById('modalContent').innerHTML = 
                        '<p>Error loading missing recipes. Please try again.</p>';
                });
        }

        // Close modal
        function closeModal() {
            document.getElementById('recipesModal').classList.remove('show');
            document.body.style.overflow = 'auto';
            setTimeout(() => {
                document.getElementById('modalContent').innerHTML = '';
            }, 300);
        }

        // Close modal when clicking outside
        window.addEventListener('click', (event) => {
            if (event.target === document.getElementById('recipesModal')) {
                closeModal();
            }
        });

        // Add animation to cards when page loads
        document.addEventListener('DOMContentLoaded', () => {
            const cards = document.querySelectorAll('.category-card, .stat-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.classList.add('fade-in');
                }, index * 100);
            });
        });
    </script>
</body>
</html>