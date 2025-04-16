<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Recipe</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            font-family: 'Capriola', sans-serif;
            background: linear-gradient(135deg, #ffffff 0%, #e9cacb 100%);
            margin: 0;
            padding: 0;
            text-align: center;
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            background-attachment: fixed;
        }

        .back-arrow {
            position: fixed;
            text-align: left;
            padding: 20px;
            font-size: 22px;
        }

        .back-arrow a {
            text-decoration: none;
            color: black;
        }

        h1 {
            text-align: center;
            color: black;
            margin-top: 20px;
        }

        form {
            max-width: 650px;
            margin: 20px auto;
            background: rgba(255, 255, 255, 0.8); /* Semi-transparent background */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        label {
            color: black;
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
        }

        input, select, textarea {
            width: 100%;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid black;
            border-radius: 8px;
        }

        textarea {
            height: 100px;
            resize: vertical;
        }

        input[type="submit"] {
            width: 25%;
            padding: 10px;
            background-color: white;
            font-weight: bold;
            border: 1px solid black;
            border-radius: 10px;
            color: black;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #f0f0f0;
        }

        .modal-content {
            border-radius: 10px;
        }

        .modal-header {
            background-color: #28a745;
            color: white;
            border-radius: 10px 10px 0 0;
        }

        .modal-footer .btn-success {
            background-color: #28a745;
            border: none;
        }

        .modal-footer .btn-danger {
            background-color: #dc3545;
            border: none;
        }
    </style>
</head>
<body>
    <%@ include file = "BackButton.jsp" %>

    <h1>Add Recipe</h1>
    <form action="AddRecipeServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <label for="name">Name of Recipe:</label>
        <input type="text" name="name" id="name" required><br>

        <label for="category">Category:</label>
        <select name="category" id="category" required>
            <option value="">Select your Category</option>
            <option value="Vegetarian">Vegetarian</option>
            <option value="Non-Vegetarian">Non-Vegetarian</option>
            <option value="Baking">Baking</option>
            <option value="Party">Party</option>
            <option value="Salad">Salad</option>
            <option value="Desserts">Desserts</option>
            <option value="Soup">Soup</option>
            <option value="Healthy">Healthy</option>
            <option value="Sweets">Sweets</option>
        </select><br>

        <label for="image">Upload Image:</label>
        <input type="file" name="image" id="image" accept="image/*" required><br>

        <label for="ingredients">Ingredients:</label>
        <textarea name="ingredients" id="ingredients" required></textarea><br>

        <label for="instructions">Instructions:</label>
        <textarea name="instructions" id="instructions" required></textarea><br>

        <label for="videoLink">Video Link:</label>
        <input type="text" name="videoLink" id="videoLink" placeholder="https://video-platform.com/video-id"><br>

        <input type="submit" value="Add Recipe">
    </form>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Success</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Recipe added successfully!
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="redirect()">OK</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Error Modal -->
    <div class="modal fade" id="errorModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Error</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    Error adding recipe. Please try again.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" onclick="redirect()">OK</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            const name = document.getElementById('name').value;
            const category = document.getElementById('category').value;
            const image = document.getElementById('image').value;
            const ingredients = document.getElementById('ingredients').value;
            const instructions = document.getElementById('instructions').value;

            if (!name || !category || !image || !ingredients || !instructions) {
                alert("All fields are required!");
                return false;
            }
            return true;
        }

        function redirect() {
            window.location.href = "AddRecipe.jsp";
        }

        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('status') === 'success') {
                new bootstrap.Modal(document.getElementById('successModal')).show();
            } else if (urlParams.get('status') === 'error') {
                new bootstrap.Modal(document.getElementById('errorModal')).show();
            }
        };
    </script>
</body>
</html>