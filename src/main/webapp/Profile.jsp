<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="jakarta.servlet.http.Cookie" %>

<%
    HttpSession userSession = request.getSession(false);
    String username = "Guest";
    String profileImage = "logo.png";
    String userId = "";

    // Retrieve username & profile image from session
    if (userSession != null) {
        if (userSession.getAttribute("username") != null) {
            username = (String) userSession.getAttribute("username");
        }
        if (userSession.getAttribute("profileImage") != null) {
            profileImage = (String) userSession.getAttribute("profileImage");
        }
        if (userSession.getAttribute("userId") != null) {
            userId = userSession.getAttribute("userId").toString(); // Fixed the type casting
        }
    } else {
        // If session is null, check for cookies
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("savedUsername")) {
                    username = cookie.getValue();
                }
            }
        }
    }

    // Get the first letter of the username for profile icon
    String firstLetter = username.substring(0, 1).toUpperCase();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile | Recipe Finder</title>
    <link href="https://fonts.googleapis.com/css2?family=Capriola&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <style>
        :root {
            --primary-bg: #f9f9f9;
            --card-bg: #ffffff;
            --menu-bg: #f0f0f0;
            --hover-bg: #e0e0e0;
            --text-color: #333333;
            --shadow: 0 4px 8px rgba(0,0,0,0.1);
            --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }

        body {
            font-family: 'Capriola', sans-serif;
            background-color: var(--primary-bg);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        .container {
            margin: 0 auto;
            padding: 20px;
        }

        .back-arrow {
            text-align: left;
            padding: 15px 0;
        }

        .back-arrow a {
            text-decoration: none;
            color: var(--text-color);
            font-size: 1.5rem;
            display: inline-flex;
            align-items: center;
            transition: var(--transition);
        }

        .back-arrow a:hover {
            transform: translateX(-3px);
        }

        .profile-section {
            margin-bottom: 20px;
        }


        .profile-image-container {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 20px;
            cursor: pointer;
        }

        .profile-image {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: grey;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
            font-weight: bold;
            overflow: hidden;
            transition: var(--transition);
        }

        .profile-image:hover {
            transform: scale(1.05);
        }

        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .username {
        	justify-content: center;
        	display:flex;
            font-size: 1.5rem;
            font-weight: bold;
            margin: 15px 0;
            color: var(--text-color);
        }

        .menu {
            background: var(--card-bg);
            border-radius: 15px;
            padding: 20px;
            box-shadow: var(--shadow);
        }

        .menu-item {
            display: flex;
            align-items: center;
            padding: 15px;
            margin: 8px 0;
            border-radius: 10px;
            font-size: 1.1rem;
            cursor: pointer;
            transition: var(--transition);
        }

        .menu-item i {
            margin-right: 15px;
            font-size: 1.3rem;
            width: 25px;
            text-align: center;
            color: #0BA5A5;
        }

        .menu-item:hover {
            background: var(--hover-bg);
            transform: translateX(5px);
        }
        
        .menu-item a {
            text-decoration: none;
            color: var(--text-color);
            flex-grow: 1;
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .modal.show {
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 1;
        }

        .modal-content {
            background-color: white;
            width: 90%;
            max-width: 600px;
            height: 80%;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            transform: translateY(-20px);
            transition: transform 0.3s ease;
            overflow: hidden;
            position: relative;
        }

        .modal.show .modal-content {
            transform: translateY(0);
        }

        .modal-content iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        .close {
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 30px;
            color: #666;
            cursor: pointer;
            z-index: 10;
            transition: var(--transition);
        }

        .close:hover {
            color: #333;
            transform: scale(1.1);
        }

        /* Responsive adjustments */
        @media (max-width: 600px) {
            .container {
                padding: 15px;
            }
            
            .profile-image-container {
                width: 100px;
                height: 100px;
            }
            
            .username {
                font-size: 1.3rem;
            }
            
            .menu-item {
                padding: 12px;
                font-size: 1rem;
            }
            
            .modal-content {
                width: 95%;
                height: 85%;
            }
        }
    </style>
</head>
<body>
<%@ include file = "BackButton.jsp" %>

    <div class="profile-section">
        <div class="profile-image-container" onclick="document.getElementById('fileInput').click()">
            <div class="profile-image">
                <% if (profileImage.equals("logo.png")) { %>
                    <%= firstLetter %>
                <% } else { %>
                    <img src="ProfileImageServlet?userId=<%= userId %>" 
                         alt="Profile Image" 
                         onerror="this.onerror=null; this.src='uploads/images/default.jpg';">
                <% } %>
            </div>
        </div>

        <form id="fileInputForm" action="ProfileServlet" method="post" enctype="multipart/form-data">
            <input type="file" name="profileImage" id="fileInput" accept="image/*" style="display: none;">
        </form>

        <div class="username"><%= username %></div>
    </div>

    <div class="menu">
        <div class="menu-item animate__animated animate__fadeInUp" style="animation-delay: 0.1s" onclick="openModal('EditName.jsp')">
            <i class="fas fa-edit"></i>
            <a href="#">Edit Name</a>
        </div>
        <div class="menu-item animate__animated animate__fadeInUp" style="animation-delay: 0.2s">
            <i class="fas fa-heart"></i>
            <a href="Favorites.jsp">Favorites</a>
        </div>
        <div class="menu-item animate__animated animate__fadeInUp" style="animation-delay: 0.3s" onclick="openModal('ChangePassword.jsp')">
            <i class="fas fa-cog"></i>
            <a href="#">Settings</a>
        </div>
        <div class="menu-item animate__animated animate__fadeInUp" style="animation-delay: 0.4s">
            <i class="fas fa-bullseye"></i>
            <a href="Ourgoals.jsp">Our Goals</a>
        </div>
        <div class="menu-item animate__animated animate__fadeInUp" style="animation-delay: 0.5s">
            <i class="fas fa-info-circle"></i>
            <a href="About.jsp">About</a>
        </div>
        <div class="menu-item animate__animated animate__fadeInUp" style="animation-delay: 0.6s" onclick="openModal('support.jsp')">
            <i class="fas fa-user-friends"></i>
            <a href="#">Support</a>
        </div>
    </div>
</div>

<!-- Modal Structure -->
<div id="contentModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <iframe id="modalIframe" src="" frameborder="0"></iframe>
    </div>
</div>

<script>
    // Handle profile image upload
    document.getElementById('fileInput').addEventListener('change', function() {
        if (this.files && this.files[0]) {
            document.getElementById('fileInputForm').submit();
        }
    });

    // Modal functions
    function openModal(pageUrl) {
        const modal = document.getElementById("contentModal");
        const iframe = document.getElementById("modalIframe");
        
        iframe.src = pageUrl;
        modal.classList.add("show");
        document.body.style.overflow = "hidden";
    }

    function closeModal() {
        const modal = document.getElementById("contentModal");
        const iframe = document.getElementById("modalIframe");
        
        modal.classList.remove("show");
        setTimeout(() => {
            iframe.src = "";
            document.body.style.overflow = "";
        }, 300);
    }

    // Close modal when clicking outside
    window.addEventListener('click', function(event) {
        const modal = document.getElementById("contentModal");
        if (event.target === modal) {
            closeModal();
        }
    });

    // Animate menu items as they come into view
    document.addEventListener("DOMContentLoaded", function() {
        const menuItems = document.querySelectorAll('.menu-item');
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = 1;
                    entry.target.style.transform = 'translateX(0)';
                }
            });
        }, { threshold: 0.1 });

        menuItems.forEach(item => {
            observer.observe(item);
        });
    });
</script>

</body>
</html>