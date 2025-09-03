<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get context path for proper image URLs
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GIP Portal | DOLE Laguna</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --dole-blue: #004d99;
            --dole-light-blue: #d0e5f5;
            --dole-yellow: #ffcc00;
            --dole-dark-blue: #003366;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Roboto', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #004d99 0%, #00aaff 100%);
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .page-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        header {
            background-color: var(--dole-blue);
            color: white;
            padding: 0;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 5%;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 1000;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            max-width: 1400px;
            margin: 0 auto;
            padding: 10px 0;
        }
        
        .logo-container {
            display: flex;
            align-items: left;
        }
        
        .header-buttons {
            display: flex;
            gap: 15px;
        }
        
        .header-buttons a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            background-color: var(--dole-dark-blue);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-size: 1em;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .header-buttons a:hover {
            background-color: #00264d;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .main-content {
            flex: 1;
            width: 100%;
            padding: 40px 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .hero-container {
            text-align: center;
            color: white;
            max-width: 800px;
            padding: 0 20px;
        }
        
        .hero-container h2 {
            font-size: 3.5rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.3);
        }
        
        .hero-container p {
            font-size: 1.5rem;
            margin-bottom: 40px;
            text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.3);
        }
        
        footer {
            text-align: center;
            padding: 25px 0;
            font-size: 1em;
            color: #FFFFFF;
            background-color: var(--dole-dark-blue);
            width: 100%;
            margin-top: auto;
        }

        footer p {
            margin: 0;
        }

        footer a {
            color: #ADD8E6;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #FFFFFF;
            text-decoration: underline;
        }
        
        /* Animation effects */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .animate-fadeIn {
            animation: fadeIn 1s ease forwards;
        }
        
        /* Responsive adjustments */
        @media (max-width: 992px) {
            .header-content {
                flex-direction: column;
                padding: 15px 0;
            }
            
            .header-buttons {
                margin-top: 15px;
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .hero-container h2 {
                font-size: 2.8rem;
            }
            
            .hero-container p {
                font-size: 1.3rem;
            }
        }
        
        @media (max-width: 768px) {
            .header-buttons a {
                padding: 10px 15px;
                font-size: 0.9em;
            }
            
            .hero-container h2 {
                font-size: 2.2rem;
            }
            
            .hero-container p {
                font-size: 1.1rem;
            }
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <header>
        <div class="header-content">
            <!-- Logo on the left -->
            <div class="logo-container">
                <img src="https://i.postimg.cc/0QvVb3kG/gip2.png" alt="GIP Portal Logo" width="95">
            </div>
            
            <!-- Header Buttons on the right -->
            <div class="header-buttons">
                <a href="<%= contextPath %>/about.jsp"><i class="fas fa-info-circle"></i> About GIP</a>


                <!-- Register Button with Icon -->
                <a href="<%= contextPath %>/register.jsp"><i class="fas fa-user-plus"></i> Register</a>
                
                <!-- Login Button with Icon -->
                <a href="<%= contextPath %>/login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
            </div>
        </div>
    </header>

    <!-- Main Content Section -->
    <main class="main-content">
        <div class="hero-container animate-fadeIn">
            <h2>Welcome to GIP Portal</h2>
            <p>Government Internship Program - Empowering the youth through meaningful government service</p>
        </div>
    </main>

    <footer>
        <p>&copy; 2025 Department of Labor and Employment | <a href="https://www.eservices.dole-laguna.com/" target="_blank">DOLE Laguna Official Website</a></p>
    </footer>
</div>

<script>
    // Add animation to elements when they come into view
    document.addEventListener('DOMContentLoaded', function() {
        const animatedElements = document.querySelectorAll('.hero-container');
        
        animatedElements.forEach(element => {
            element.classList.add('animate-fadeIn');
        });
    });
</script>
</body>
</html>


