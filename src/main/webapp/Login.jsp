<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Page</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    * {
    	color: black;
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: 'Poppins', sans-serif;
        background: linear-gradient(135deg, #ffffff 0%, #e9cacb 100%);
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 20px;
    }

    .container {
        width: 90%;
        max-width: 450px;
        padding: 40px;
        background: rgba(255, 255, 255, 0.95);
        border-radius: 24px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.2);
        backdrop-filter: blur(10px);
        transform: translateY(0);
        transition: all 0.3s ease;
    }

    .container:hover {
        transform: translateY(-5px);
        box-shadow: 0 25px 50px rgba(0, 0, 0, 0.25);
    }

    .sign {
        text-align: center;
        margin-bottom: 35px;
    }

    h3 {
        font-weight: 600;
        position: relative;
        display: inline-block;
    }

    h3::after {
        content: '';
        position: absolute;
        bottom: -8px;
        left: 50%;
        transform: translateX(-50%);
        width: 50px;
        height: 3px;
        border-radius: 2px;
    }

    .form-group {
        position: relative;
        margin-bottom: 25px;
    }

    .form-group i {
        position: absolute;
        left: 20px;
        top: 50%;
        transform: translateY(-50%);
        color: #667eea;
        transition: all 0.3s ease;
    }

    .form-group:focus-within i {
        color: #764ba2;
    }

    input[type="text"], input[type="password"] {
        width: 100%;
        padding: 16px 16px 16px 50px;
        border: 2px solid #e0e0e0;
        border-radius: 12px;
        font-size: 16px;
        transition: all 0.3s ease;
        background: white;
        color: #2c3e50;
    }

    input::placeholder {
        color: #95a5a6;
    }

    input:focus {
        outline: none;
        border-color: #667eea;
        box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
    }

    .password-toggle {
        position: absolute;
        right: 20px;
        top: 50%;
        transform: translateY(-50%);
        color: #95a5a6;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .password-toggle:hover {
        color: #667eea;
    }

    .options {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin: 20px 0;
        font-size: 14px;
        color: #7f8c8d;
    }

    .remember {
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .remember input[type="checkbox"] {
        width: 18px;
        height: 18px;
        accent-color: #667eea;
    }

    .forgot-password a {
        color: #667eea;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.3s ease;
        position: relative;
    }

    .forgot-password a::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        width: 0;
        height: 2px;
        background: linear-gradient(90deg, #667eea, #764ba2);
        transition: width 0.3s ease;
    }

    .forgot-password a:hover::after {
        width: 100%;
    }

    button {
        width: 100%;
        padding: 16px;
        background: #e82626;
        color: white;
        border: none;
        border-radius: 12px;
        font-size: 16px;
        font-weight: 500;
        cursor: pointer;
        margin-top: 25px;
        transition: all 0.3s ease;
        position: relative;
        overflow: hidden;
    }

    button::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
        transition: 0.5s;
    }

    button:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(102, 126, 234, 0.4);
    }

    button:hover::before {
        left: 100%;
    }

    .signup {
        margin-top: 25px;
        font-size: 15px;
        color: black;
        text-align: center;
    }

    .signup a {
        color: #667eea;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.3s ease;
        position: relative;
    }

    .signup a::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        width: 0;
        height: 2px;
        background: linear-gradient(90deg, #667eea, #764ba2);
        transition: width 0.3s ease;
    }

    .signup a:hover::after {
        width: 100%;
    }

    .error {
        color: #e74c3c;
        font-size: 14px;
        background: rgba(231, 76, 60, 0.1);
        padding: 12px;
        border-radius: 8px;
        margin-bottom: 20px;
        text-align: center;
        border: 1px solid rgba(231, 76, 60, 0.2);
    }

    .success {
        color: #2ecc71;
        font-size: 14px;
        background: rgba(46, 204, 113, 0.1);
        padding: 12px;
        border-radius: 8px;
        margin-bottom: 20px;
        text-align: center;
        border: 1px solid rgba(46, 204, 113, 0.2);
    }

    @media (max-width: 480px) {
        .container {
            padding: 30px 20px;
        }

        h3 {
            font-size: 28px;
        }

        .options {
            flex-direction: column;
            gap: 15px;
            align-items: flex-start;
        }
    }
</style>
</head>
<%@ include file = "BackButton.jsp" %>

<%
    String savedEmail = "";
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("userEmail")) {
                savedEmail = cookie.getValue();
            }
        }
    }
%>

<div class="container">
    <div class="sign">
        <h3>Sign in to your account</h3>
    </div>

    <% String error = request.getParameter("error");
       String success = request.getParameter("success");
       if (error != null) { %>
           <p class="error"><%= error %></p>
    <% } else if (success != null) { %>
           <p class="success"><%= success %></p>
    <% } %>

    <form action="LoginServlet" method="post">
        <div class="form-group">
            <i class="fas fa-envelope"></i>
            <input type="text" name="email" placeholder="Email" value="<%= savedEmail %>" required>
        </div>
        <div class="form-group">
            <i class="fas fa-lock"></i>
            <input type="password" name="password" id="password" placeholder="Password" required>
        </div>

        <div class="options">
            <div class="remember">
                <input type="checkbox" name="rememberMe" id="rememberMe" <%= savedEmail.isEmpty() ? "" : "checked" %>>
                <label for="rememberMe">Remember Me</label>
            </div>
        </div>

        <button type="submit">Sign in</button>
    </form>

    <div class="signup">
        Don't have an account? <a href="Signup.jsp">Sign Up</a>
    </div>
</div>

</body>
</html>
