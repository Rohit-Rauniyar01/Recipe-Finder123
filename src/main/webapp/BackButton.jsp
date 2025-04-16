<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // Check user role
    String role = (String) session.getAttribute("role");
    String redirectPage = "HomePage.jsp"; // Default for users
    
    if ("admin".equals(role)) {
        redirectPage = "AdminPanal.jsp";
    }
    
    // Check cookies if session is null
    if (role == null) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("role")) {
                    role = cookie.getValue();
                    if ("admin".equals(role)) {
                        redirectPage = "AdminPanal.jsp";
                    }
                    break;
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Back Arrow Button</title>
<link href="https://fonts.googleapis.com/css2?family=Capriola&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">

<style>
    /* CSS Variables */
    :root {
        --primary-color: #e40046;
        --secondary-color: #0BA5A5;
        --accent-color: #f50057;
        --white: #ffffff;
        --transition: all 0.3s ease;
    }
    
    body {
        margin: 0;
        padding: 0;
        font-family: 'Capriola', sans-serif;
    }

    /* Back Button */
    .back-btn {
        position: fixed;
        top: 20px;
        left: 20px;
        background-color: var(--primary-color);
        color: var(--white);
        padding: 8px 15px;
        border-radius: 5px;
        text-decoration: none;
        transition: var(--transition);
        display: flex;
        align-items: center;
        gap: 5px;
        z-index: 1000;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    }

    .back-btn:hover {
        background-color: var(--accent-color);
        transform: translateX(-3px);
    }
</style>
</head>
<body>
    <a href="<%= redirectPage %>" class="back-btn animate__animated animate__fadeIn">
        <i class="fas fa-arrow-left"></i> Back
    </a>
</body>
</html>