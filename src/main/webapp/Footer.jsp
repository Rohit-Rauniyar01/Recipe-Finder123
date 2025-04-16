<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Footer</title>
<link href="https://fonts.googleapis.com/css2?family=Capriola&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: Capriola, sans-serif;
            margin: 0;
            padding: 0;
        }

        /* Footer Styling */
        .footer {
            display: flex;
            justify-content: space-between	;
            align-items: center;
            background-color: #F5F5F5;
            padding: 20px;
            border-top: 1px solid #ccc;
        }

        /* Logo Container */
        .footer-logo img {
            width: 150px;
            margin-left: 40px
        }

        /* Links Container */
        .footer-links {
            display: flex;
            flex-direction: column;
            text-align: left;
        }

        .footer-links a {
            text-decoration: none;
            color: black;
            font-size: 16px;
            margin: 5px 0;
        }

        /* Feedback Form */
        .footer-feedback {
            max-width: 300px;
        }

        .footer-feedback h3 {
            margin-bottom: 5px;
            margin-left: -60px;
        }

        .footer-feedback p {
            font-size: 14px;
            margin-bottom: 10px;
            margin-left: -60px;
        }

        .footer-feedback input, .footer-feedback textarea {
            width: 100%;
            padding: 15px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-left: -60px;
        }

        .footer-feedback button {
            background-color: white;
            border: 1px solid black;
            border-radius: 10px;
            padding: 5px 10px;
            cursor: pointer;
        }

        .footer-feedback button:hover {
            background-color: #e0e0e0;
        }

        /* Copyright */
        .footer-copyright {
            text-align: center;
            padding: 10px;
            font-size: 14px;
            background-color: #F5F5F5;
        }
    </style>
</head>
<body>

    <footer class="footer">
        <!-- Logo Section -->
        <div class="footer-logo">
            <img src="logo.png" alt="Recipe Finder Logo">
        </div>

        <!-- About Links -->
        <div class="footer-links">
            <a href="About.jsp">About</a>
            <a href="Ourgoals.jsp">Our Goals</a>
            <a href="support.jsp">Contact</a>
        </div>

    </footer>

    <div class="footer-copyright">
        © Recipe-Finder All Rights Reserved
    </div>

</body>
</html>
