<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Signup Page</title>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    * {
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

    .back-arrow {
        position: fixed;
        top: 25px;
        left: 25px;
        font-size: 24px;
        z-index: 100;
    }

    .back-arrow a {
        text-decoration: none;
        color: white;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .back-arrow a:hover {
        color: #fff;
        transform: translateX(-5px);
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
        margin-bottom: 10px;
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

    input[type="text"], input[type="email"], input[type="password"] {
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

    .login-link {
        margin-top: 25px;
        font-size: 15px;
        color: black;
        text-align: center;
    }

    .login-link a {
        color: #667eea;
        text-decoration: none;
        font-weight: 500;
        transition: all 0.3s ease;
        position: relative;
    }

    .login-link a::after {
        content: '';
        position: absolute;
        bottom: -2px;
        left: 0;
        width: 0;
        height: 2px;
        background: linear-gradient(90deg, #667eea, #764ba2);
        transition: width 0.3s ease;
    }

    .login-link a:hover::after {
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

    @media (max-width: 480px) {
        .container {
            padding: 30px 20px;
        }

        h3 {
            font-size: 28px;
        }

        .back-arrow {
            top: 15px;
            left: 15px;
        }
    }
</style>
</head>
<body>

<%@ include file = "BackButton.jsp" %>

<div class="container">
    <div class="sign">
        <h3>Create your account</h3>
    </div>
    
    <!-- Display error messages if any -->
<% String error = request.getParameter("error");
   if (error != null && !error.trim().isEmpty()) { %>
       <p class="error"><%= error %></p>
<% } %>

    
    <form action="SignUpServlet" method="post">
        <div class="form-group">
            <i class="fas fa-user"></i>
            <input type="text" name="username" placeholder="Username" required>
        </div>
        <div class="form-group">
            <i class="fas fa-envelope"></i>
            <input type="email" name="email" placeholder="Email" required>
        </div>
        <div class="form-group">
            <i class="fas fa-lock"></i>
            <input type="password" name="password" id="password" placeholder="Password" required>
            
        </div>
        <button type="submit">Sign up</button>
    </form>

    <div class="login-link">
        Already got an account? <a href="Login.jsp">Sign in</a>
    </div>
</div>

<script>
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.querySelector('.password-toggle');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.classList.remove('fa-eye');
        toggleIcon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        toggleIcon.classList.remove('fa-eye-slash');
        toggleIcon.classList.add('fa-eye');
    }
}



document.getElementById('password').addEventListener('input', function(e) {
    checkPasswordStrength(e.target.value);
});
</script>

</body>
</html>
