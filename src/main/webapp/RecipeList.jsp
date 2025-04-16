<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Recipe List | RecipeFinder</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #ff6b6b;
            --primary-light: #ff8e8e;
            --primary-dark: #ff4757;
            --secondary-color: #4ecdc4;
            --dark-color: #292f36;
            --light-color: #f7fff7;
            --gray-light: #f5f5f5;
            --gray-medium: #e0e0e0;
            --gray-dark: #757575;
            --success-color: #2ecc71;
            --error-color: #e74c3c;
            --border-radius: 8px;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f9f9f9;
            color: var(--dark-color);
        }

        .header-container {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 var(--border-radius) var(--border-radius);
            box-shadow: var(--box-shadow);
        }

        .page-title {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .page-subtitle {
            font-weight: 300;
            opacity: 0.9;
        }

        .search-container {
            max-width: 800px;
            margin: 0 auto 2rem;
            padding: 0 1rem;
        }

        .search-box {
            display: flex;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
            transition: var(--transition);
        }

        .search-box:focus-within {
            box-shadow: 0 0 0 3px rgba(255, 107, 107, 0.2);
        }

        .search-input {
            flex: 1;
            padding: 0.75rem 1.25rem;
            border: none;
            outline: none;
            font-family: 'Poppins', sans-serif;
            font-size: 1rem;
        }

        .search-btn {
            padding: 0 1.5rem;
            background-color: var(--primary-color);
            color: white;
            border: none;
            cursor: pointer;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .search-btn:hover {
            background-color: var(--primary-dark);
        }

        .recipe-table-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 1rem;
        }

        .recipe-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            overflow: hidden;
        }

        .recipe-table th {
            background-color: var(--gray-light);
            padding: 1rem;
            text-align: left;
            font-weight: 500;
            color: var(--dark-color);
        }

        .recipe-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-medium);
            vertical-align: middle;
        }

        .recipe-table tr:last-child td {
            border-bottom: none;
        }

        .recipe-table tr:hover {
            background-color: rgba(255, 107, 107, 0.05);
        }

        .action-btns {
            display: flex;
            gap: 0.5rem;
        }

        .btn-action {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: none;
            cursor: pointer;
            transition: var(--transition);
        }

        .btn-edit {
            background-color: rgba(255, 193, 7, 0.1);
            color: #ffc107;
        }

        .btn-edit:hover {
            background-color: rgba(255, 193, 7, 0.2);
            transform: translateY(-2px);
        }

        .btn-delete {
            background-color: rgba(220, 53, 69, 0.1);
            color: #dc3545;
        }

        .btn-delete:hover {
            background-color: rgba(220, 53, 69, 0.2);
            transform: translateY(-2px);
        }

        .no-recipes {
            text-align: center;
            padding: 2rem;
            color: var(--gray-dark);
        }

        .no-recipes i {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: var(--gray-medium);
        }

        /* Modal styles */
        .modal-content {
            border-radius: var(--border-radius);
            border: none;
            box-shadow: var(--box-shadow);
        }

        .modal-header {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 1.25rem;
        }

        .modal-title {
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .modal-body {
            padding: 1.5rem;
        }

        /* Loading animation */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .loading-spinner {
            width: 40px;
            height: 40px;
            border: 4px solid rgba(255, 107, 107, 0.1);
            border-top: 4px solid var(--primary-color);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 2rem auto;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .header-container {
                padding: 1.5rem 0;
            }
            
            .page-title {
                font-size: 1.5rem;
            }
            
            .recipe-table th, 
            .recipe-table td {
                padding: 0.75rem;
            }
            
            .action-btns {
                gap: 0.25rem;
            }
            
            .btn-action {
                width: 32px;
                height: 32px;
                font-size: 0.9rem;
            }
        }

        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-fade {
            animation: fadeIn 0.5s ease forwards;
        }
    </style>
</head>
<body>

<%@ include file = "BackButton.jsp" %>
    <div class="header-container animate-fade">
        <div class="container text-center">
            <h1 class="page-title"><i class="fas fa-utensils me-2"></i>Recipe List</h1>
            <p class="page-subtitle">Manage all your recipes in one place</p>
        </div>
    </div>

    <div class="search-container animate-fade delay-1">
        <form method="GET" action="RecipeList.jsp" class="search-box">
            <input type="text" name="query" class="search-input" placeholder="Search recipes..." 
                   value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
            <button type="submit" class="search-btn">
                <i class="fas fa-search"></i> Search
            </button>
        </form>
    </div>

    <div class="recipe-table-container animate-fade delay-2">
        <table class="recipe-table">
            <thead>
                <tr>
                    <th>Recipe Name</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String searchQuery = request.getParameter("query") == null ? "" : request.getParameter("query");

                    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/RecipeFinder", "root", "root");
                         PreparedStatement stmt = conn.prepareStatement(
                             searchQuery.isEmpty() ? "SELECT id, name FROM Recipes" :
                             "SELECT id, name FROM Recipes WHERE name LIKE ?")) {

                        if (!searchQuery.isEmpty()) {
                            stmt.setString(1, "%" + searchQuery + "%");
                        }

                        ResultSet rs = stmt.executeQuery();
                        boolean hasResults = false;
                        
                        while (rs.next()) {
                            hasResults = true;
                            int recipeId = rs.getInt("id");
                            String recipeName = rs.getString("name");
                %>
                            <tr>
                                <td><%= recipeName %></td>
                                <td>
                                    <div class="action-btns">
                                        <button type="button" class="btn-action btn-edit" onclick="openUpdateModal(<%= recipeId %>)" 
                                                title="Edit recipe">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <form method="POST" action="deleteRecipe.jsp" onsubmit="return confirmDelete();" style="display:inline;">
                                            <input type="hidden" name="id" value="<%= recipeId %>">
                                            <button type="submit" class="btn-action btn-delete" title="Delete recipe">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                <%
                        }

                        if (!hasResults) {
                %>
                            <tr>
                                <td colspan="2" class="no-recipes">
                                    <i class="fas fa-utensil-spoon"></i>
                                    <p>No recipes found</p>
                                </td>
                            </tr>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                %>
                        <tr>
                            <td colspan="2" class="no-recipes">
                                <i class="fas fa-exclamation-triangle"></i>
                                <p>Error loading recipes: <%= e.getMessage() %></p>
                            </td>
                        </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

    <!-- Update Recipe Modal -->
    <div class="modal fade" id="updateRecipeModal" tabindex="-1" aria-labelledby="updateRecipeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Update Recipe</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="updateRecipeContent">
                    <div class="loading-spinner"></div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Open update modal with recipe details
        function openUpdateModal(recipeId) {
            const modalContent = document.getElementById("updateRecipeContent");
            modalContent.innerHTML = '<div class="loading-spinner"></div>';
            
            const updateModal = new bootstrap.Modal(document.getElementById("updateRecipeModal"));
            updateModal.show();
            
            fetch("UpdateRecipe.jsp?id=" + recipeId)
                .then(response => response.text())
                .then(data => {
                    modalContent.innerHTML = data;
                })
                .catch(error => {
                    modalContent.innerHTML = `
                        <div class="text-center py-4">
                            <i class="fas fa-exclamation-triangle fa-2x text-danger mb-3"></i>
                            <p>Error loading recipe details. Please try again.</p>
                            <button class="btn btn-primary" onclick="openUpdateModal(${recipeId})">
                                <i class="fas fa-redo me-2"></i>Retry
                            </button>
                        </div>
                    `;
                });
        }

        // Confirm before deleting
        function confirmDelete() {
            return confirm("Are you sure you want to delete this recipe?\nThis action cannot be undone.");
        }

        // Add animation delays
        document.querySelectorAll('.animate-fade').forEach((el, index) => {
            el.style.animationDelay = `${index * 0.1}s`;
        });
    </script>
</body>
</html>